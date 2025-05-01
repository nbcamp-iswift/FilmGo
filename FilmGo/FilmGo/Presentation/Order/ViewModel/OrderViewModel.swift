//
//  OrderViewModel.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation
import RxSwift
import RxRelay

final class OrderViewModel: ViewModelProtocol {
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()

    let disposeBag = DisposeBag()

    init(movie: Movie) {
        state = BehaviorRelay(value: State(movie: movie))
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectDate(let index):
            Observable.just(.setSelectedDateIndex(index))
        case .selectTime(let index):
            Observable.just(.setSelectedTimeIndex(index))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setSelectedDateIndex(let index):
            newState.selectedDateIndex = index
        case .setSelectedTimeIndex(let index):
            newState.selectedTimeIndex = index
        }

        let condition = newState.selectedDateIndex != nil && newState.selectedTimeIndex != nil
        newState.selectSeatButtonIsEnabled = condition

        return newState
    }
}

extension OrderViewModel {
    enum Action {
        case selectDate(Int)
        case selectTime(Int)
    }

    enum Mutation {
        case setSelectedDateIndex(Int)
        case setSelectedTimeIndex(Int)
    }

    struct State {
        var movie: Movie
        var selectedDateIndex: Int?
        var selectedTimeIndex: Int?
        var selectSeatButtonIsEnabled: Bool = false
    }
}
