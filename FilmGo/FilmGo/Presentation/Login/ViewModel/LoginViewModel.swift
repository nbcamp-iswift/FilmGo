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
    let useCase: UserUseCase
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(useCase: UserUseCase) {
        self.useCase = useCase
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> RxSwift.Observable<Mutation> {
        switch action {
        case .didTapLoginButton:
            let isLoginSuccess = isLoginSuccess()
            // isLoginSuccess로 조건 분기: false이면 setIsLogoutFailed
            return .concat([
                .just(.setIsLogin(true)),
                .just(.setIsLogin(false)),
            ])
        case .didChangeEmailTextField(let input):
            return .just(.setEmail(input))
        case .didChangePasswordTextFiedl(let input):
            return .just(.setPassword(input))
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
        case .setEmail(let input):
            newState.email = input
            newState.isEnabledLogin = setEnabledLoginButton(state: newState)
        case .setPassword(let input):
            newState.password = input
            newState.isEnabledLogin = setEnabledLoginButton(state: newState)
        case .setIsLogin(let isLogin):
            newState.isLogin = isLogin
        case .setPushSignUpVC(let isSignUp):
            newState.pushSignUpVC = isSignUp
        }
        return newState
    }
}

extension LoginViewModel {
    func setEnabledLoginButton(state: State) -> Bool {
        !state.email.isEmpty && !state.password.isEmpty
    }

    func isLoginSuccess() -> Bool {
        let current = state.value
        return useCase.login(email: current.email, password: current.password)
    }
}

extension LoginViewModel {
    enum Action {
        case didTapLoginButton
        case didChangeEmailTextField(String)
        case didChangePasswordTextFiedl(String)
        case didTapSignUpButton
    }

    enum Mutation {
        case setEmail(String)
        case setPassword(String)
        case setIsLogin(Bool)
        case setPushSignUpVC(Bool)
    }

    struct State {
        var email: String = ""
        var password: String = ""
        var isEnabledLogin: Bool = false
        var isLogin: Bool = false
        var pushSignUpVC: Bool = false
    }
}
