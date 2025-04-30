//
//  HomeViewModel.swift
//  FilmGo
//
//  Created by 유현진 on 4/28/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelProtocol {
    enum Action {
        case fetchNowPlaying
        case fetchPopular
    }

    enum Mutation {
        case setNowPlaying([MovieSectionItem])
        case setPopular([MovieSectionItem])
    }

    struct State {
        var movie: [MovieSectionItem] = []
        var nowPlayingPage: Int = 0
        var popularPage: Int = 0
    }

    var state: BehaviorRelay<State>
    var action = PublishRelay<Action>()
    var useCase: MovieUseCaseProtocol
    var disposeBag: DisposeBag

    init(useCase: MovieUseCaseProtocol) {
        state = BehaviorRelay(value: State())
        disposeBag = DisposeBag()
        self.useCase = useCase
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNowPlaying:
            return useCase.fetchNowPlaying(page: 1)
                .map { .setNowPlaying($0.movies.map { .nowPlaying($0) }) }
        case .fetchPopular:
            return useCase.fetchPopular(page: 1)
                .map { .setPopular($0.movies.map { .popular($0) }) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNowPlaying(let models):
            newState.movie += models
        case .setPopular(let models):
            newState.movie += models
        }
        return newState
    }
}
