//
//  SeatItem.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation

struct SeatItem: Hashable {
    let number: Int
    let state: State
}

extension SeatItem {
    enum State {
        case selectable
        case alreadySelected
        case selecting
    }
}
