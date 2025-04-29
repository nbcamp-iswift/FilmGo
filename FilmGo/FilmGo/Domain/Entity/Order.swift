import Foundation

// TODO: Move this to CoreData ?
struct Order: Hashable {
    let movieName: String
    let postImageURL: String
    let orderedDate: Date
    let seats: [String]
}
