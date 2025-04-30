//
//  LoginViewModel.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel: ViewModelProtocol {
    // TODO: UseCase 추가
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(isLogin: Bool) {
        state = BehaviorRelay(value: State(isLogin: isLogin))
    }

    func mutate(action: Action) -> RxSwift.Observable<Mutation> {
        switch action {
        case .didTapLoginButton:
            return .concat([
                .just(.setIsLogin(true)),
                .just(.setIsLogin(false)),
            ])
        case .didTapSignUpButton:
            return .concat([
                .just(.setPushSignUpVC(true)),
                .just(.setPushSignUpVC(false)),
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsLogin(let isLogin):
            newState.isLogin = isLogin
        case .setPushSignUpVC(let isSignUp):
            newState.pushSignUpVC = isSignUp
        }
    }
}

extension LoginViewModel {
    enum Action {
        case didTapLoginButton
        case didTapSignUpButton
    }

    enum Mutation {
        case setIsLogin(Bool)
        case setPushSignUpVC(Bool)
    }

    struct State {
        var isLogin: Bool
        var pushSignUpVC: Bool = false
    }
}
