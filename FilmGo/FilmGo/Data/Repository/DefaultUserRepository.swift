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

    func login(email: String, password: String) -> Bool {
        // TODO: fetchUser로 유저 불러와서 password 매칭, loginUser로 로그인 처리 후 true 반환
        // TODO: 매칭 실패 시 false 반환
        true
    }

    func logout(userId: Int) {
        storage.logoutUser(userId: userId)
    }
}
