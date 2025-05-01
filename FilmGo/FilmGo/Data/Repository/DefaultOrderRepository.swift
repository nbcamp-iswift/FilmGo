//
//  DefaultOrderRepository.swift
//  FilmGo
//
//  Created by youseokhwan on 5/1/25.
//

import Foundation
import RxSwift

final class DefaultOrderRepository: OrderRepositoryProtocol {
    private let storage: CoreDataStorage

    init(storage: CoreDataStorage) {
        self.storage = storage
    }

    func createOrder(movieId: Int, seats: [String]) -> Single<Bool> {
        Single.create { [weak self] emitter in
            guard let self else {
                emitter(.failure(CoreDataStorageError.unknownError))
                return Disposables.create()
            }
            do {
                try emitter(.success(storage.createOrder(movieId: movieId, seats: seats)))
            } catch {
                emitter(.failure(CoreDataStorageError.unknownError))
            }
            return Disposables.create()
        }
    }
}
