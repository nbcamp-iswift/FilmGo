//
//  UserRepositoryProtocol.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func registerUser(email: String, name: String, password: String)
    func login(email: String, password: String) -> Bool
}
