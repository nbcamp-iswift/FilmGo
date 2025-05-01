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
            let user = useCase.getUser()
            let orders = (user?.orders as? NSOrderedSet)?
                .compactMap { $0 as? Order } ?? []
            return .concat([
                .just(.setUserInfo(user)),
                .just(.setOrders(orders)),
            ])
        case .didTapLogout:
            useCase.logout()
            return .just(.setIsLogout(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUserInfo(let user):
            newState.user = user
        case .setOrders(let orders):
            newState.orders = orders
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
        case setUserInfo(User?)
        case setOrders([Order])
        case setIsLogout(Bool)
    }

    struct State {
        var user: User?
        var orders: [Order] = []
        var isLogout: Bool = false
    }
}
