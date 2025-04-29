import Foundation

struct MoviesRequestDTO: Encodable {
    let language: String
    let page: Int
    let region: String

    init(page: Int) {
        language = "ko-KR"
        self.page = page
        region = "KR"
    }
}

struct MovieDetailRequestDTO: Encodable {
    let movieID: Int
    let language: String
    let appendToResponse: String?

    init(movieID: Int, appendToResponse: String? = nil) {
        self.movieID = movieID
        language = "ko-KR"
        self.appendToResponse = appendToResponse
    }
}

struct MovieCreditsRequestDTO: Encodable {
    let movieID: Int
    let language: String

    init(movieID: Int) {
        self.movieID = movieID
        language = "ko-KR"
    }
}
