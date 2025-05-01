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
    private let userUseCase: UserUseCase
    private let movieUseCase: MovieUseCase
    var state: BehaviorRelay<State>
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    init(userUseCase: UserUseCase, movieUseCase: MovieUseCase) {
        self.userUseCase = userUseCase
        self.movieUseCase = movieUseCase
        state = BehaviorRelay(value: State())
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let user = userUseCase.getUser()
            return .just(.setUserInfo(user))
        case .viewWillAppear:
            let user = userUseCase.getUser()
            let orders = (user?.orders as? NSOrderedSet)?
                .compactMap { $0 as? Order } ?? []
            return setOrders(from: orders)
        case .didTapLogout:
            userUseCase.logout()
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

private extension MyPageViewModel {
    func setOrders(from orders: [Order]) -> Observable<Mutation> {
        Observable.from(orders)
            .flatMap { [weak self] order -> Observable<OrderCellModel> in
                guard let self else { return .empty() }
                return movieUseCase.execute(for: Int(order.movieid))
                    .map { movie in
                        let seatsString = order.seats.joined(separator: " ")
                        return OrderCellModel(
                            movieTitle: movie.title,
                            date: order.orderedDate,
                            seats: seatsString
                        )
                    }
            }
            .toArray()
            .asObservable()
            .map { .setOrders($0) }
    }
}

extension MyPageViewModel {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case didTapLogout
    }

    enum Mutation {
        case setUserInfo(User?)
        case setOrders([OrderCellModel])
        case setIsLogout(Bool)
    }

    struct State {
        var user: User?
        var orders: [OrderCellModel] = []
        var isLogout: Bool = false
    }
}
