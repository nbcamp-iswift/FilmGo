import Foundation
import CoreData

public extension User {
    @nonobjc class func fetchRequest() -> NSFetchRequest<User> {
        NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var isLogin: Bool
    @NSManaged var orders: NSOrderedSet?
}

// MARK: Generated accessors for orders

public extension User {
    @objc(insertObject:inOrdersAtIndex:)
    @NSManaged func insertIntoOrders(_ value: Order, at idx: Int)

    @objc(removeObjectFromOrdersAtIndex:)
    @NSManaged func removeFromOrders(at idx: Int)

    @objc(insertOrders:atIndexes:)
    @NSManaged func insertIntoOrders(_ values: [Order], at indexes: NSIndexSet)

    @objc(removeOrdersAtIndexes:)
    @NSManaged func removeFromOrders(at indexes: NSIndexSet)

    @objc(replaceObjectInOrdersAtIndex:withObject:)
    @NSManaged func replaceOrders(at idx: Int, with value: Order)

    @objc(replaceOrdersAtIndexes:withOrders:)
    @NSManaged func replaceOrders(at indexes: NSIndexSet, with values: [Order])

    @objc(addOrdersObject:)
    @NSManaged func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged func addToOrders(_ values: NSOrderedSet)

    @objc(removeOrders:)
    @NSManaged func removeFromOrders(_ values: NSOrderedSet)
}

extension User: Identifiable {}
