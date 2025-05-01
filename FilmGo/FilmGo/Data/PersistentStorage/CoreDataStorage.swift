import CoreData
import RxSwift

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case userNotFound
    case unknownError
}

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    private init() {}

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

// MARK: - User & Order

extension CoreDataStorage {
    func loginUser(email: String, password: String) -> Bool {
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

    func createOrder(movieId: Int, seats: [String], orderedDate: Date = Date()) throws -> Bool {
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

        return true
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

    private func updateOrder(orderId: UUID, updateBlock: (Order) -> Void) throws {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", orderId as CVarArg)
        request.fetchLimit = 1

        guard let order = try context.fetch(request).first else {
            throw CoreDataStorageError.userNotFound
        }

        updateBlock(order)
        saveContext()
    }
}

// MARK: - MovieDO

extension CoreDataStorage {
    func saveMovie(_ movie: Movie) {
        if let existedMovie = fetchMovieEntity(movieId: movie.movieId) {
            existedMovie.title = movie.title
            existedMovie.star = movie.star
            existedMovie.runningTime = movie.runningTime
            existedMovie.posterPath = movie.posterImagePath
            existedMovie.genre = movie.genres
            existedMovie.overview = movie.overview
            existedMovie.releasedYear = Int64(movie.releasedYear)
            existedMovie.director = movie.director
            existedMovie.actors = movie.actors
        } else {
            let newEntity = MovieDO(context: context)
            newEntity.id = Int64(movie.movieId)
            newEntity.title = movie.title
            newEntity.star = movie.star
            newEntity.runningTime = movie.runningTime
            newEntity.posterPath = movie.posterImagePath
            newEntity.genre = movie.genres
            newEntity.overview = movie.overview
            newEntity.releasedYear = Int64(movie.releasedYear)
            newEntity.director = movie.director
            newEntity.actors = movie.actors
        }
        saveContext()
    }

    func saveMovies(_ movies: [Movie]) {
        for movie in movies {
            saveMovie(movie)
        }
    }

    func saveMovieImage(id: Int, imageData: Data) {
        guard let movie = fetchMovieEntity(movieId: id) else {
            return
        }
        movie.posterImage = imageData
        saveContext()
    }

    func searchMovie(movieTitle: String) -> [Movie] {
        let request: NSFetchRequest<MovieDO> = MovieDO.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", movieTitle)

        do {
            return try context.fetch(request)
                .map { $0.toDomain() }
        } catch {
            return []
        }
    }

    func fetchMovieEntity(movieId: Int) -> MovieDO? {
        let request: NSFetchRequest<MovieDO> = MovieDO.fetchRequest()
        request.predicate = NSPredicate(format: "id==%d", movieId)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
}

// MARK: - Common

extension CoreDataStorage {
    func clearAllData() {
        let entityNames = ["User", "Order", "MovieDO"]
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
                #if DEBUG
                    print("Error deleting \(entityName): \(error)")
                #endif
            }
        }
    }
}
