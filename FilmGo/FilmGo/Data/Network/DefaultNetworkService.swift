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

    func request<T: Decodable, U: Encodable>(
        type: NetworkServiceType,
        queryParameters: U?
    ) -> Single<T>

    func downloadImage(from url: URL) -> Single<Data>
}

final class DefaultNetworkService: NetworkServiceProtocol {
    func downloadImage(from url: URL) -> Single<Data> {
        return Single<Data>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NetworkError.cancelled))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, res, err in
                if let err = err {
                    single(.failure(NetworkError.network(err)))
                    return
                }

                guard let data = data else {
                    single(.failure(NetworkError.noData))
                    return
                }

                single(.success(data))
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    func request<T: Decodable, U: Encodable>(
        type: NetworkServiceType,
        queryParameters: U?
    ) -> Single<T> {
        return request(
            url: type.url,
            method: type.method,
            queryParameters: queryParameters,
            headers: type.headers
        )
    }

    func request<T:Decodable, U: Encodable>(
        url: URL,
        method: String,
        queryParameters: U?,
        headers: [String : String]
    ) -> Single<T>
    {
        return Single<T>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NetworkError.cancelled))
                return Disposables.create()
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
                    single(.failure(NetworkError.requestEncodingFailed(error)))
                    return Disposables.create()
                }
            }

            guard let fullURL = component?.url else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }

            var req = URLRequest(url: fullURL)
            req.httpMethod = method
            headers.forEach { key, value in
                req.setValue(value, forHTTPHeaderField: key)
            }

            let task = URLSession.shared.dataTask(with: req) { data, res, err in
                if let err = err as? URLError {
                    switch err.code {
                    case .notConnectedToInternet:
                        single(.failure(NetworkError.notConnected))
                    case .cancelled:
                        single(.failure(NetworkError.cancelled))
                    case .timedOut:
                        single(.failure(NetworkError.timeout))
                    default:
                        single(.failure(NetworkError.network(err)))
                    }
                    return
                } else if let err = err {
                    single(.failure(NetworkError.network(err)))
                    return
                }

                guard let data = data, !data.isEmpty else {
                    single(.failure(NetworkError.noData))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(NetworkError.decodingFailed(error)))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
