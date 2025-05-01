//
//  SeatItem.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation

struct SeatItem: Hashable {
    let seatNumber: Int
    var userID: String
    var state: State
}

extension SeatItem {
    enum State: Int {
        case selectable = 0
        case alreadySelected = 1
        case selecting = 2
    }
}
