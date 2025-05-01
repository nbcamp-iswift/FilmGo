//
//  SearchViewModel.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel: ViewModelProtocol {
    enum Action {
        case fetchSearchResult(String)
    }

    enum Mutation {
        case setSearchResult([Movie])
    }

    struct State {
        var movie: [Movie] = []
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
        case .fetchSearchResult(let keyword):
            return useCase.fetchMoviesByTitle(movieTitle: keyword)
                .map { .setSearchResult($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchResult(let models):
            newState.movie = models
        }
        return newState
    }
}
