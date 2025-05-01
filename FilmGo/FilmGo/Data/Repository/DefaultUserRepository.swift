import Foundation

final class DefaultUserRepository: UserRepositoryProtocol {
    private let storage: CoreDataStorage

    init(storage: CoreDataStorage) {
        self.storage = storage
    }

    func registerUser(email: String, name: String, password: String) {
        storage.createUser(
            name: name,
            email: email,
            password: password
        )
    }

    func login(email: String, password: String) -> Bool {
        storage.loginUser(email: email, password: password)
    }

    func logoutCurrentUser() {
        /// Assumption: Only one user(loggedIn.True) can logout
        /// Logic:      Fetch Loggedin User, if not just return
        guard let user = storage.fetchLoggedInUser() else { return }
        storage.logoutUser(userId: user.id)
    }
}
