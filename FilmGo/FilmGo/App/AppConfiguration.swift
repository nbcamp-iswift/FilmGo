import Foundation

/// Work as an Environment Config Mapper
/// Forced as SingleTon Class
final class AppConfiguration {
    static let shared = AppConfiguration()
    private init() {}

    private lazy var apiBaseURL: String = getValue(for: "API_BASE_URL")
    private lazy var nowPlayingPath: String = getValue(for: "NOW_PLAYING_PATH")
    private lazy var popularPath: String = getValue(for: "POPULAR_PATH")
    private lazy var movieDetailPath: String = getValue(for: "MOVIE_DETAIL_PATH")
    private lazy var movieCreditPath: String = getValue(for: "MOVIE_CREDIT_PATH")

    var nowPlayingURL: URL {
        makeURL(path: nowPlayingPath)
    }

    var popularURL: URL {
        makeURL(path: popularPath)
    }

    func movieDetailURL(movieID: Int) -> URL {
        let path = movieDetailPath.replacingOccurrences(of: "{movie_id}", with: "\(movieID)")
        return makeURL(path: path)
    }

    func movieCreditURL(movieID: Int) -> URL {
        let path = movieCreditPath.replacingOccurrences(of: "{movie_id}", with: "\(movieID)")
        return makeURL(path: path)
    }

    private func makeURL(path: String) -> URL {
        guard let url = URL(string: apiBaseURL + path) else {
            print("Failed to create URL")
        }
        return url
    }

    private func getValue(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("\(key) is not defined in Info.plist")
        }
        return value
    }
}
