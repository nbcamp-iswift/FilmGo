//
//  FetchMovieUseCase.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import Foundation
import RxSwift

final class FetchMovieUseCase: FetchableMovieUseCase {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(for id: Int) -> Observable<Movie> {
        repository.fetchMovieEntity(id: id).asObservable()
    }
}
