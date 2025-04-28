import Foundation

struct Movies {
    let movieId: Int
    let poserImage: Data
    let title: String
    let star: Double
    let runningTime: String
    let releasedYear: Int
    let genres: [String]
    let director: String
    let actors: [String]
}

struct NowPlayingMovie {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movies]
}

struct PopularMovies {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movies]
}

// TODO: Move this to CoreData
struct SearchMovie {
    let currentPage: Int
    let totalPages: Int
    let movies: [Movies]
}
