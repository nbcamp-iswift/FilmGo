//
//  SignUpViewModel.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelProtocol {
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init() {
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> RxSwift.Observable<Mutation> {
        switch action {
        case .didTapSignUpButton:
            return .just(.setIsSignUp(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsSignUp(let bool):
            newState.isSignUp = bool
        }
        return newState
    }
}

extension SignUpViewModel {
    enum Action {
        case didTapSignUpButton
    }

    enum Mutation {
        case setIsSignUp(Bool)
    }

    struct State {
        var isSignUp: Bool = false
    }
}
