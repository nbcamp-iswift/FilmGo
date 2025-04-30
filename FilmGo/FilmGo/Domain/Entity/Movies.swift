import Foundation

struct Movie {
    let movieId: Int
    let posterImage: Data
    let title: String
    let star: Double
    let runningTime: String
    let releasedYear: Int
    let genres: [String]
    let overview: String
    let director: String
    let actors: [String]
}

struct MovieBrief {
    let movieId: Int
    let posterImage: Data
    let title: String
    let star: Double
    let runningTime: String
    let releasedYear: Int
    let genres: [String]
}

struct NowPlayingMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [MovieBrief]
}

struct PopularMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [MovieBrief]
}

// TODO: Move this to CoreData
struct SearchMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [MovieBrief]
}
