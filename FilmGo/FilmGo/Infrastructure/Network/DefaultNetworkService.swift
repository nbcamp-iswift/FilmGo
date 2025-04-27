import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case requestEncodingFailed(Error)

    case notConnected
    case cancelled
    case timeout
    case network(Error)

    case noData
    case decodingFailed(Error)
}

protocol NetworkServiceType {
    func request <T: Decodable, U: Encodable>(
        url: URL,
        method: String,
        requestedBody: U?
    ) -> Single<T>
}

final class DefaultNetworkService: NetworkServiceType {
    private let config: NetworkConfiguration

    init(config: NetworkConfiguration) {
        self.config = config
    }

    func request<T: Decodable, U: Encodable>(
        url: URL,
        method: String,
        requestedBody: U?
    ) -> Single<T> {
        return Single<T>.create { [weak self] in
            guard let self = self else {
                throw NetworkError.cancelled
            }

            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

            if !self.config.queryParms.isEmpty {
                components?.queryItems = self.config.queryParms.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
            }

            guard let fullUrl = components?.url else {
                throw NetworkError.invalidURL
            }

            var req = URLRequest(url: fullUrl)
            req.httpMethod = method

            self.config.headers.forEach { key, value in
                req.setValue(value, forHTTPHeaderField: key)
            }

            if let body = requestedBody {
                do {
                    // Set content type to JSON
                    req.httpBody = try JSONEncoder().encode(body)
                    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    throw NetworkError.requestEncodingFailed(error)
                }
            }

            do {
                let (data, res) = try await URLSession.shared.data(for: req)
                guard let httpResponse = res as? HTTPURLResponse else {
                    throw NetworkError.invalidRequest
                }

                switch httpResponse.statusCode {
                case 200..<300:
                    break
                default:
                    throw NetworkError.invalidRequest
                }

                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded

            } catch let urlErr as URLError {
                switch urlErr.code {
                case .notConnectedToInternet:
                    throw NetworkError.notConnected
                case .cancelled:
                    throw NetworkError.cancelled
                case .timedOut:
                    throw NetworkError.timeout
                default:
                    throw NetworkError.network(urlErr)
                }
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        }
    }
}
