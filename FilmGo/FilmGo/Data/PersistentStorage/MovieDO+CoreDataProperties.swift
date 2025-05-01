import Foundation
import CoreData

public extension MovieDO {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieDO> {
        NSFetchRequest<MovieDO>(entityName: "MovieDO")
    }

    @NSManaged var id: Int64 // movie-id
    @NSManaged var title: String
    @NSManaged var star: String
    @NSManaged var runningTime: String
    @NSManaged var posterPath: String
    @NSManaged var genre: [String]?
    @NSManaged var posterImage: Data?
}

extension MovieDO: Identifiable {}

extension MovieDO {
    func toDomain() -> Movie {
        Movie(
            movieId: Int(id),
            posterImagePath: posterPath,
            title: title,
            star: star,
            runningTime: runningTime,
            releasedYear: 0,
            genres: genre ?? [],
            overview: "",
            director: "",
            actors: []
        )
    }
}
