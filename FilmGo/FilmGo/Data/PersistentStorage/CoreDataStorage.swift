import CoreData
import RxSwift

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case userNotFound
}

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FilmGo")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

extension CoreDataStorage {
    func loginUser(email: String, password:String) -> Bool {
        guard let user = fetchUser(byEmail: email), user.password == password else {
            return false
        }
        user.isLogin = true
        saveContext()
        return true
    }

    func logoutUser(userId: UUID) {
        guard let user = fetchUser(byId: userId) else { return }
        user.isLogin = false
        saveContext()
    }

    func fetchUser(byId id: UUID) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func fetchUser(byEmail email: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func fetchLoggedInUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isLogin == true")
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func createUser(
        name: String,
        email: String,
        password: String,
        isLogin: Bool = false
    ) {
        let newUser = User(context: context)
        newUser.id = UUID()
        newUser.name = name
        newUser.email = email
        newUser.password = password
        newUser.isLogin = isLogin
        saveContext()
    }

    func createOrder(movieId: Int, seats: [String], orderedDate: Date = Date()) throws {
        guard let user = fetchLoggedInUser() else {
            throw CoreDataStorageError.userNotFound
        }

        let order = Order(context: context)
        order.id = UUID()
        order.movieid = Int64(movieId)
        order.orderedDate = orderedDate
        order.seats = seats
        order.user = user
        saveContext()
    }

    func fetchOrders(forUser userId: UUID) -> [Order] {
        guard let user = fetchUser(byId: userId),
              let order = user.orders?.array as? [Order] else {
            return []
        }
        return order
    }

    func addSeat(orderId: UUID, seat: String) throws {
        try updateOrder(orderId: orderId) { order in
            var updated = order.seats ?? []
            updated.append(seat)
            order.seats = Array(Set(updated))
        }
    }

    func addSeats(orderId: UUID, seats: [String]) throws {
        try updateOrder(orderId: orderId) { order in
            var updated = order.seats ?? []
            updated.append(contentsOf: seats)
            order.seats = Array(Set(updated))
        }
    }

    private func updateOrder(orderId: UUID, updateBlock: (Order)->Void) throws {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", orderId as CVarArg)
        request.fetchLimit = 1

        guard let order = try context.fetch(request).first else {
            throw CoreDataStorageError.userNotFound
        }

        updateBlock(order)
        saveContext()
    }

    func clearAllData() {
        let entityNames = ["User", "Order"]
        for entityName in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
                entityName: entityName
            )
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try persistentContainer.persistentStoreCoordinator.execute(
                    deleteRequest, with: context
                )
            } catch {
                print("Error deleting \(entityName): \(error)")
            }
        }

        saveContext()
    }
}
