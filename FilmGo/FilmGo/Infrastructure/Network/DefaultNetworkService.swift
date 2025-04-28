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

protocol NetworkServiceProtocol {
    func request <T: Decodable, U: Encodable>(
        url: URL,
        method: String,
        queryParameters: U?,
        headers: [String: String]
    ) -> Single<T>
}

final class DefaultNetworkService: NetworkServiceProtocol {
    func request<T, U>(
        url: URL,
        method: String,
        queryParameters: U?,
        headers: [String : String]
    ) -> Single<T> where T : Decodable, U : Encodable
    {
        return Single<T>.create { [weak self] in
            guard let self = self else {
                throw NetworkError.cancelled
            }

            var component = URLComponents(url: url, resolvingAgainstBaseURL: false)

            if let query = queryParameters {
                do {
                    let queryData = try JSONEncoder().encode(query)
                    if let queryDict = try JSONSerialization.jsonObject(with: queryData) as? [String: Any] {
                        component?.queryItems = queryDict.map {
                            URLQueryItem(name: $0.key, value: "\($0.value)")
                        }
                    }
                } catch {
                    throw NetworkError.requestEncodingFailed(error)
                }
            }

            guard let fullURL = component?.url else {
                throw NetworkError.invalidURL
            }

            var req = URLRequest(url: fullURL)
            req.httpMethod = method

            headers.forEach { key, value in
                req.setValue(value, forHTTPHeaderField: key)
            }

            do {
                let (data, res) = try await URLSession.shared.data(for: req)
                guard let httpRes = res as? HTTPURLResponse,
                        (200..<300).contains(httpRes.statusCode) else {
                    throw NetworkError.invalidRequest
                }

                guard !data.isEmpty else {
                    throw NetworkError.noData
                }

                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch let error as URLError {
                switch error.code {
                case .notConnectedToInternet:
                    throw NetworkError.notConnected
                case .cancelled:
                    throw NetworkError.cancelled
                case .timedOut:
                    throw NetworkError.timeout
                default:
                    throw NetworkError.network(error)
                }
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        }
    }
}
