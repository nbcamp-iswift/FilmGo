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

    let disposeBag = DisposeBag()

    init(movie: Movie) {
        state = BehaviorRelay(value: State(movie: movie))
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {}
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {}
        return newState
    }
}

extension DetailViewModel {
    enum Action {}

    enum Mutation {}

    struct State {
        var movie: Movie
    }
}
