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
    let useCase: UserUseCase
    var state: BehaviorRelay<State>
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(useCase: UserUseCase) {
        self.useCase = useCase
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case .didTapLogout:
            useCase.logout()
            return .just(.setIsLogout(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUserInfo(let name, let email):
            newState.name = name
            newState.email = email
        case .setIsLogout(let isLogout):
            newState.isLogout = isLogout
        }
        return newState
    }
}

extension MyPageViewModel {
    enum Action {
        case viewDidLoad
        case didTapLogout
    }

    enum Mutation {
        case setUserInfo(String, String)
        case setIsLogout(Bool)
    }

    struct State {
        var name: String = ""
        var email: String = ""
        var isLogout: Bool = false
    }
}
