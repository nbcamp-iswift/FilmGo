import Foundation
import CoreData

public extension Order {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Order> {
        NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged var id: Int64
    @NSManaged var movieid: Int64
    @NSManaged var orderedDate: Date?
    @NSManaged var seats: NSObject?
    @NSManaged var userid: Int64
    @NSManaged var user: User?
}

extension Order: Identifiable {}
