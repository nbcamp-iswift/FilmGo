//
//  MyPageViewModel.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import Foundation
import RxSwift
import RxRelay

final class MyPageViewModel: ViewModelProtocol {
    let logoutUseCase: LogoutUseCase
    var state: BehaviorRelay<State>
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> RxSwift.Observable<Mutation> {
        switch action {
        case .didTapLogout:
            return .just(.setIsLogout(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsLogout(let isLogout):
            newState.isLogout = isLogout
        }
        return newState
    }
}

extension MyPageViewModel {
    enum Action {
        case didTapLogout
    }

    enum Mutation {
        case setIsLogout(Bool)
    }

    struct State {
        var isLogout: Bool = false
    }
}
