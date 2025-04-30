//
//  DefaultUserRepository.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import Foundation

final class DefaultUserRepository: UserRepositoryProtocol {
    private let storage: CoreDataStorage

    init(storage: CoreDataStorage) {
        self.storage = storage
    }

    func registerUser(email: String, name: String, password: String) {
        storage.createUser(
            id: 1,
            name: name,
            email: email,
            password: password
        )
    }
}
