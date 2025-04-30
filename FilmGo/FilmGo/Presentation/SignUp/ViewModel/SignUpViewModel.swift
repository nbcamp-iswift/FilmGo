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
        case .didTapBackButton:
            return .just(.setBackToLogin(true))
        case .didTapSignUpButton:
            return .just(.setIsSignUp(true))
        case .didTapLoginButton:
            return .just(.setBackToLogin(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBackToLogin(let isBack):
            newState.backToLogin = isBack
        case .setIsSignUp(let bool):
            newState.isSignUp = bool
        }
        return newState
    }
}

extension SignUpViewModel {
    enum Action {
        case didTapBackButton
        case didTapSignUpButton
        case didTapLoginButton
    }

    enum Mutation {
        case setBackToLogin(Bool)
        case setIsSignUp(Bool)
    }

    struct State {
        var backToLogin: Bool = false
        var isSignUp: Bool = false
    }
}
