//
//  UserUseCase.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import Foundation

final class UserUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func registerUser(email: String, name: String, password: String) {
        repository.registerUser(email: email, name: name, password: password)
    }

    func getUser() -> User? {
        repository.getCurrentUser()
    }

    func login(email: String, password: String) -> Bool {
        repository.login(email: email, password: password)
    }

    func logout() {
        repository.logoutCurrentUser()
    }
}
