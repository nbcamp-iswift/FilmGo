import Foundation
import RxSwift

// https://www.themoviedb.org/talk/53c11d4ec3a3684cf4006400
enum TMDBPosterSize: String {
    case w92, w154, w185, w342, w500, w780, original
}

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
    func request<T: Decodable, U: Encodable>(
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
    func downloadImage(
        path: String,
        size: TMDBPosterSize
    ) -> Single<Data>
}

final class DefaultNetworkService: NetworkServiceProtocol {
    func downloadImage(
        path: String,
        size: TMDBPosterSize = .w500
    ) -> Single<Data> {
        let base = BundleConfig.get(.imageBaseURL)
        let urlString = base + "/\(size.rawValue)" + path
        guard let url = URL(string: urlString) else {
            return .error(NetworkError.invalidURL)
        }
        return downloadImage(from: url)
    }

    func request<T: Decodable>(
        type: NetworkServiceType,
        queryParameters: (some Encodable)?
    ) -> Single<T> {
        request(
            url: type.url,
            method: type.method,
            queryParameters: queryParameters,
            headers: type.headers
        )
    }

    func downloadImage(from url: URL) -> Single<Data> {
        Single<Data>.create { [weak self] single in
            guard let self else {
                single(.failure(NetworkError.cancelled))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, err in
                if let err {
                    single(.failure(NetworkError.network(err)))
                    return
                }

                guard let data else {
                    single(.failure(NetworkError.noData))
                    return
                }

                single(.success(data))
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    func request<T: Decodable>(
        url: URL,
        method: String,
        queryParameters: (some Encodable)?,
        headers: [String: String]
    ) -> Single<T> {
        Single<T>.create { [weak self] single in
            guard let self else {
                single(.failure(NetworkError.cancelled))
                return Disposables.create()
            }

            var component = URLComponents(url: url, resolvingAgainstBaseURL: false)

            if let query = queryParameters {
                do {
                    let queryData = try JSONEncoder().encode(query)
                    if let queryDict = try JSONSerialization.jsonObject(
                        with: queryData
                    ) as? [String: Any] {
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
            req.timeoutInterval = 10
            headers.forEach { key, value in
                req.setValue(value, forHTTPHeaderField: key)
            }

            let task = URLSession.shared.dataTask(with: req) { data, _, err in
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
                } else if let err {
                    single(.failure(NetworkError.network(err)))
                    return
                }

                guard let data, !data.isEmpty else {
                    single(.failure(NetworkError.noData))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decoded))
                } catch let decodingError as DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), context: \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), context: \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), context: \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                    single(.failure(NetworkError.decodingFailed(decodingError)))
                } catch {
                    single(.failure(NetworkError.network(error)))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
