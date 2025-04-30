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
    let signUpUseCase: SignUpUseCase
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> RxSwift.Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            return .just(.setBackToLogin(true))
        case .didChangeEmailTextField(let input):
            return .just(.setEmail(input))
        case .didChangeNameTextField(let input):
            return .just(.setName(input))
        case .didChangePasswordTextField(let input):
            return .just(.setPassword(input))
        case .didChangeConfirmPasswordTextField(let input):
            return .just(.setConfirmPassword(input))
        case .didTapSignUpButton:
            // TODO: isUniqueEmail()로 register를 할지 조건 분기, setIsSignUp 입력으로도 넣음
            register()
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
        case .setEmail(let input):
            newState.email = input
            newState.isEnabledSignUp = setSignUpButton(state: newState)
        case .setName(let input):
            newState.name = input
            newState.isEnabledSignUp = setSignUpButton(state: newState)
        case .setPassword(let input):
            newState.password = input
            newState.isEnabledSignUp = setSignUpButton(state: newState)
        case .setConfirmPassword(let input):
            newState.confirmPassword = input
            newState.isEnabledSignUp = setSignUpButton(state: newState)
        case .setIsSignUp(let bool):
            newState.isSignUp = bool
        }
        return newState
    }
}

extension SignUpViewModel {
    func setSignUpButton(state: State) -> Bool {
        let isFilledEveryTextField =
            !state.email.isEmpty &&
            !state.name.isEmpty &&
            !state.password.isEmpty &&
            !state.confirmPassword.isEmpty
        let isPasswordMatched = state.password == state.confirmPassword
        return isFilledEveryTextField && isPasswordMatched
    }

    func isUniqueEmail() -> Bool {
        // TODO: fetchUser를 통해 체크
        true
    }

    func register() {
        let current = state.value

        signUpUseCase.registerUser(
            email: current.email,
            name: current.name,
            password: current.password
        )
    }
}

extension SignUpViewModel {
    enum Action {
        case didTapBackButton
        case didChangeEmailTextField(String)
        case didChangeNameTextField(String)
        case didChangePasswordTextField(String)
        case didChangeConfirmPasswordTextField(String)
        case didTapSignUpButton
        case didTapLoginButton
    }

    enum Mutation {
        case setBackToLogin(Bool)
        case setEmail(String)
        case setName(String)
        case setPassword(String)
        case setConfirmPassword(String)
        case setIsSignUp(Bool)
    }

    struct State {
        var backToLogin: Bool = false
        var email: String = ""
        var name: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var isEnabledSignUp: Bool = false
        var isSignUp: Bool = false
    }
}
