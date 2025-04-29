import Foundation

struct Movie {
    let movieId: Int
    let posterImage: Data
    let title: String
    let star: Double
    let runningTime: String
    let releasedYear: Int
    let genres: [String]
    let director: String
    let actors: [String]
}

struct NowPlayingMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movie]
}

struct PopularMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movie]
}

// TODO: Move this to CoreData
struct SearchMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movie]
}
