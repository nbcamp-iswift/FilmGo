import Foundation
import CoreData

extension MovieDO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDO> {
        return NSFetchRequest<MovieDO>(entityName: "MovieDO")
    }

    @NSManaged public var id: Int64 // movie-id
    @NSManaged public var title: String
    @NSManaged public var star: String
    @NSManaged public var runningTime: String
    @NSManaged public var posterPath: String
    @NSManaged public var genre: [String]?
    @NSManaged public var posterImage: Data?
}

extension MovieDO : Identifiable {}

extension MovieDO {
    func toDomain() -> Movie {
        return Movie(
            movieId: Int(self.id),
            posterImagePath: self.posterPath,
            title: self.title,
            star: self.star,
            runningTime: self.runningTime,
            releasedYear: 0,
            genres: self.genre ?? [],
            overview: "",
            director: "",
            actors: []
        )
    }
}
