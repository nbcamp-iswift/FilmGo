//
//  OrderUseCase.swift
//  FilmGo
//
//  Created by youseokhwan on 5/1/25.
//

import Foundation
import RxSwift

final class OrderUseCase {
    private let repository: OrderRepositoryProtocol

    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }

    func createOrder(movieID: Int, seats: [Int]) -> Observable<Bool> {
        repository
            .createOrder(movieId: movieID, seats: seats.map { "\($0)" })
            .asObservable()
    }
}
