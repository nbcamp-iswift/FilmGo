//
//  SignUpUseCase.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import Foundation

final class SignUpUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func registerUser(email: String, name: String, password: String) {
        repository.registerUser(email: email, name: name, password: password)
    }

    func checkDuplicateEmail(email: String) {}
}
