import CoreData
import RxSwift

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case userNotFound
}

// TODO: Define Protocol
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
    func loginUser(userId: Int) {
        guard let user = fetchUser(by: Int64(userId)) else { return }
        user.isLogin = true
        saveContext()
    }

    func logoutUser(userId: Int) {
        guard let user = fetchUser(by: Int64(userId)) else { return }
        user.isLogin = false
        saveContext()
    }

    func fetchUser(by id: Int64) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", id)
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
        id: Int,
        name: String,
        email: String,
        password: String,
        isLogin: Bool = false
    ) {
        let newUser = User(context: context)
        newUser.id = Int64(id)
        newUser.name = name
        newUser.email = email
        newUser.password = password
        newUser.isLogin = isLogin
        saveContext()
    }

    func createOrder(id: Int, movieID: Int, orderedDate: Date, seats: [String]) throws {
        guard let user = fetchLoggedInUser() else {
            throw CoreDataStorageError.userNotFound
        }

        let newOrder = Order(context: context)
        newOrder.id = Int64(id)
        newOrder.movieid = Int64(movieID)
        newOrder.orderedDate = orderedDate
        newOrder.seats = seats as NSArray
        newOrder.userid = user.id
        newOrder.user = user
        user.addToOrders(newOrder)
        saveContext()
    }

    func fetchOrders(for userId: Int64) -> [Order] {
        guard let user = fetchUser(by: userId),
              let order = user.orders?.array as? [Order] else {
            return []
        }
        return order
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
