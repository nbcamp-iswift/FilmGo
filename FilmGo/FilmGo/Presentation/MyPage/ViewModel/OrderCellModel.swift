//
//  OrderCellModel.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import Foundation

struct OrderCellModel: Hashable {
    let movieTitle: String
    let date: Date
    let seats: String
    var isUpComming: Bool {
        date >= Date()
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
