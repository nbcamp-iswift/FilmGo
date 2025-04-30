//
//  DetailViewModel.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel: ViewModelProtocol {
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()

    let fetchMovieUseCase: FetchableMovieUseCase
    let disposeBag = DisposeBag()

    init(movieID: Int, fetchMovieUseCase: FetchableMovieUseCase) {
        state = BehaviorRelay(value: State(movieID: movieID))
        self.fetchMovieUseCase = fetchMovieUseCase
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovie:
            fetchMovieUseCase.execute(for: state.value.movieID)
                .map { Mutation.setMovie($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        }

        return newState
    }
}

extension DetailViewModel {
    enum Action {
        case fetchMovie
    }

    enum Mutation {
        case setMovie(Movie)
    }

    struct State {
        var movieID: Int
        var movie: Movie?
    }
}
