//
//  OrderRepositoryProtocol.swift
//  FilmGo
//
//  Created by youseokhwan on 5/1/25.
//

import Foundation
import RxSwift

protocol OrderRepositoryProtocol {
    func createOrder(movieId: Int, seats: [String], date: Date) -> Single<Bool>
}
