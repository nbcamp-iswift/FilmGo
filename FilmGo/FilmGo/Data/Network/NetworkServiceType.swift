import Foundation

enum BundleConfigKey: String {
    case baseURL = "BASE_API_URL"
    case accessToken = "ACCESS_TOKEN"
    case nowPlayingPath = "NOW_PLAYING_PATH"
    case popularPath = "MOVIE_POPULAR_PATH"
    case movieDetailPath = "MOVIE_DETAIL_PATH"
    case movieCreditPath = "MOVIE_CREDIT_PATH"
    case imageBaseURL = "IMAGE_BASE_URL" // https://developer.themoviedb.org/docs/image-basics
}

enum BundleConfig {
    static func get(_ key: BundleConfigKey) -> String {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            fatalError("Missing config value for key: \(key.rawValue)")
        }
        return value
    }
}

enum NetworkServiceType {
    case nowPlaying
    case popular
    case movieDetail(movieID: Int)
    case movieCredit(movieID: Int)
}

extension NetworkServiceType {
    private var baseURL: String {
        BundleConfig.get(.baseURL)
    }

    private var accessToken: String {
        BundleConfig.get(.accessToken)
    }

    private var path: String {
        switch self {
        case .nowPlaying:
            return BundleConfig.get(.nowPlayingPath)
        case .popular:
            return BundleConfig.get(.popularPath)
        case .movieDetail(let id):
            return BundleConfig.get(.movieDetailPath)
                .replacingOccurrences(of: "{movie_id}", with: "\(id)")
        case .movieCredit(let id):
            return BundleConfig.get(.movieCreditPath)
                .replacingOccurrences(of: "{movie_id}", with: "\(id)")
        }
    }

    var url: URL {
        guard let url = URL(string: baseURL + path) else {
            fatalError("Invalid URL for NetworkServiceType")
        }
        return url
    }

    var method: String {
        "GET"
    }

    var headers: [String: String] {
        [
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}
