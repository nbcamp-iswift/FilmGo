import Foundation
import CoreData

public extension Order {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Order> {
        NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged var id: UUID
    @NSManaged var movieid: Int64
    @NSManaged var orderedDate: Date
    @NSManaged var seats: [String]?
    @NSManaged var user: User?
}

extension Order: Identifiable {}
