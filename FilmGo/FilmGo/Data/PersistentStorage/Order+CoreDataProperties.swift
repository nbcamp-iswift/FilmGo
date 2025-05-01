import Foundation
import CoreData


extension Order {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: UUID
    @NSManaged public var movieid: Int64
    @NSManaged public var orderedDate: Date?
    @NSManaged public var seats: [String]?
    @NSManaged public var user: User?
}

extension Order : Identifiable {}
