import Foundation
import CoreData

extension Order {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var orderedDate: Date
    @NSManaged public var id: Int64
    @NSManaged public var movieid: Int64
    @NSManaged public var userid: Int64
    @NSManaged public var seats: NSObject?
    @NSManaged public var user: User?
}
