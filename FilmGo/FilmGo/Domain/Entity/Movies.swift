import Foundation

struct Movie: Hashable {
    let movieId: Int
    let posterImagePath: String
    let title: String
    let star: String
    let runningTime: String
    let releasedYear: Int
    let genres: [String]
    let overview: String
    let director: String
    let actors: [String]
}

struct PaginatedMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movie]
}

// typealias NowPlayingMovies = PaginatedMovies
// typealias PopularMovies = PaginatedMovies
