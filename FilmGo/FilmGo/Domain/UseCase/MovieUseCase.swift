//
//  MovieUseCase.swift
//  FilmGo
//
//  Created by 유현진 on 4/30/25.
//

import Foundation
import RxSwift

final class MovieUseCase: MovieUseCaseProtocol {
    let repository: DefaultMovieRepository

    init(repository: DefaultMovieRepository) {
        self.repository = repository
    }

    func fetchNowPlaying(page: Int) -> Observable<PaginatedMovies> {
        repository.fetchNowPlayingMovies(page: page).asObservable()
    }

    func fetchPopular(page: Int) -> Observable<PaginatedMovies> {
        repository.fetchPopularMovies(page: page).asObservable()
    }
}
