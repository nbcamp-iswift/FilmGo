import Foundation

struct MoviesRequestDTO: Encodable {
    let language: String
    let page: Int
    let region: String?
}
