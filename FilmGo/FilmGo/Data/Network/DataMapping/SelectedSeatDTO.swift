//
//  SelectedSeatDTO.swift
//  FilmGo
//
//  Created by youseokhwan on 5/1/25.
//

import Foundation

struct SelectedSeatDTO: Decodable {
    let id: Int
    let movieID: Int
    let seatNumber: Int
    let userID: String
    let state: Int
}

struct SelectedSeatRequestDTO: Encodable {
    let movieID: Int
    let seatNumber: Int
    let userID: String
    let state: Int
}
