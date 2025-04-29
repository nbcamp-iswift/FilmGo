//
//  MockModel.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import Foundation

struct User {
    let name: String
    let email: String
}

struct Order: Hashable {
    let id: Int
    let movie: Movie
    let date: Date
    let seats: [String]
}

struct Movie: Hashable {
    let title: String
}
