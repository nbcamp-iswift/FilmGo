import Foundation

/// Work as an Environment Config Mapper
final class AppConfiguration {
    private lazy var apiBaseURL: String = getValue(for: "API_BASE_URL")

    private lazy var nowPlayingPath: String = getValue(for: "NOW_PLAYING_PATH")

    private lazy var popularPath: String = getValue(for: "POPULAR_PATH")

    private lazy var topRatedPath: String = getValue(for: "TOP_RATED_PATH")

    private lazy var movieimagePath: String = getValue(for: "MOVIE_IMAGE_PATH")

    var nowPlayingURL: String {
        apiBaseURL + nowPlayingPath
    }

    var popularURL: String {
        apiBaseURL + popularPath
    }

    var topRatedURL: String {
        apiBaseURL + topRatedPath
    }

    func movieImageURL(for movieID: Int) -> String {
        let path = movieimagePath.replacingOccurrences(of: "$(MOVIE_ID)", with: "\(movieID)")
        return apiBaseURL + path
    }

    private func getValue(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("\(key) is not defined in Info.plist")
        }
        return value
    }
}
