//
//  LoginUseCase.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import Foundation

final class LoginUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func login(email: String, password: String) -> Bool {
        repository.login(email: email, password: password)
    }
}
