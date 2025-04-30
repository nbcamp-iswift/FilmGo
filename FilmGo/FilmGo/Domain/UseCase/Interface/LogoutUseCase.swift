//
//  LogoutUseCase.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import Foundation

final class LogoutUseCase {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func logout(userId: Int) {
        repository.logout(userId: userId)
    }
}
