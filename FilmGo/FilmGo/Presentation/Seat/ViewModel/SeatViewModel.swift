//
//  SeatViewModel.swift
//  FilmGo
//
//  Created by youseokhwan on 4/30/25.
//

import Foundation
import RxSwift
import RxRelay

final class SeatViewModel: ViewModelProtocol {
    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()

    let useCase: OrderUseCase
    let disposeBag = DisposeBag()

    init(movie: Movie, useCase: OrderUseCase) {
        self.useCase = useCase
        state = BehaviorRelay(value: State(movie: movie))
        SupabaseService.shared.startListening(for: movie.movieId)
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.startListening)
        case .didTapCell(let seatNumber):
            return .just(.selectSeat(seatNumber))
        case .didTapPayButton:
            let randomDate = Calendar.current.date(
                byAdding: .day,
                value: Int.random(in: 1 ... 3),
                to: Date()
            )
            return useCase.createOrder(
                movieID: state.value.movie.movieId,
                seats: state.value.selectingSeatsByCurrentUser.map(\.seatNumber),
                date: randomDate ?? Date()
            )
            .map { result in
                .updateFinishCreateOrder(result)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        // TODO: Domain 및 Data Layer로 책임 분리 필요
        switch mutation {
        case .startListening:
            SupabaseService.shared.selectedSeats
                .subscribe(onNext: { [weak self] seats in
                    guard let self else { return }
                    self.state.accept(.init(
                        movie: state.movie,
                        selectedSeats: seats,
                        selectingSeatsByCurrentUser: seats.filter {
                            $0.userID == CoreDataStorage.shared.fetchLoggedInUser()?.id.uuidString
                                && $0.state == .selecting
                        }
                    ))
                })
                .disposed(by: disposeBag)
        case .selectSeat(let seatNumber):
            SupabaseService.shared.toggleSelectedSeat(
                movieID: state.movie.movieId,
                seatNumber: seatNumber,
            )
        case .updateFinishCreateOrder(let result):
            newState.finishCreateOrder = result
        }

        return newState
    }

    deinit {
        SupabaseService.shared.endListening()
    }
}

extension SeatViewModel {
    enum Action {
        case viewDidLoad
        case didTapCell(Int)
        case didTapPayButton
    }

    enum Mutation {
        case startListening
        case selectSeat(Int)
        case updateFinishCreateOrder(Bool)
    }

    struct State {
        var movie: Movie
        var selectedSeats = [SeatItem]()
        var selectingSeatsByCurrentUser = [SeatItem]()
        var finishCreateOrder: Bool?
    }
}
