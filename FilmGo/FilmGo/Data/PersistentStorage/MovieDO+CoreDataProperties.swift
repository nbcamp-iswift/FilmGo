import Foundation
import CoreData

public extension MovieDO {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieDO> {
        NSFetchRequest<MovieDO>(entityName: "MovieDO")
    }

    @NSManaged var genre: [String]?
    @NSManaged var id: Int64
    @NSManaged var posterImage: Data?
    @NSManaged var posterPath: String?
    @NSManaged var runningTime: String?
    @NSManaged var star: String?
    @NSManaged var title: String?
    @NSManaged var overview: String?
    @NSManaged var director: String?
    @NSManaged var actors: [String]?
    @NSManaged var releasedYear: Int64
}

extension MovieDO: Identifiable {}

extension MovieDO {
    func toDomain() -> Movie {
        Movie(
            movieId: Int(id),
            posterImagePath: posterPath ?? "",
            title: title ?? "",
            star: star ?? "",
            runningTime: runningTime ?? "",
            releasedYear: Int(releasedYear),
            genres: genre ?? [],
            overview: overview ?? "",
            director: director ?? "",
            actors: actors ?? []
        )
    }
}
