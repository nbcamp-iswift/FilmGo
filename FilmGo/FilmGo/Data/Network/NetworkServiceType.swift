import Foundation

enum NetworkServiceType {
    case nowPlaying
    case popular
    case movieDetail(movieID: Int)
    case movieCredit(movieID: Int)
}

extension NetworkServiceType {
    private var baseURL: String {
        getValue(for: "BASE_API_URL")
    }

    private var accessToken: String {
        getValue(for: "ACCESS_TOKEN")
    }

    private var nowPlayingPath: String {
        getValue(for: "NOW_PLAYING_PATH")
    }

    private var popularPath: String {
        getValue(for: "MOVIE_POPULAR_PATH")
    }

    private var movieDetailPath: String {
        getValue(for: "MOVIE_DETAIL_PATH")
    }

    private var movieCreditPath: String {
        getValue(for: "MOVIE_CREDIT_PATH")
    }

    var url: URL {
        let fullPath: String
        switch self {
        case .nowPlaying:
            fullPath = nowPlayingPath
        case .popular:
            fullPath = popularPath
        case .movieDetail(let id):
            fullPath = movieDetailPath.replacingOccurrences(of: "{movie_id}", with: "\(id)")
        case .movieCredit(let id):
            fullPath = movieCreditPath.replacingOccurrences(of: "{movie_id}", with: "\(id)")
        }

        guard let url = URL(string: baseURL + fullPath) else {
            fatalError("NetworkServiceType: Failed to Create a full length URL")
        }
        return url
    }

    var method: String {
        "GET"
    }

    var headers: [String: String] {
        ["Authorization": "Bearer \(accessToken)"]
    }

    private func getValue(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Failed to retrieve key: \(key) from info.plist")
        }
        return value
    }
}
