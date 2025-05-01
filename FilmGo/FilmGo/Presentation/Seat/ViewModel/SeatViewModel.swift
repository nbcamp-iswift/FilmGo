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

    let disposeBag = DisposeBag()

    init(movie: Movie) {
        state = BehaviorRelay(value: State(movie: movie))
        bind()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            .just(.startListening)
        case .didTapCell(let seatNumber):
            .just(.selectSeat(seatNumber))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        // TODO: Domain Layer로 책임 분리 필요
        switch mutation {
        case .startListening:
            SupabaseService.shared.startListening(for: state.movie.movieId)
            SupabaseService.shared.selectedSeats
                .subscribe(onNext: { [weak self] seats in
                    guard let self else { return }
                    self.state.accept(.init(movie: state.movie, selectedSeats: seats))
                })
                .disposed(by: disposeBag)
        case .selectSeat(let seatNumber):
            SupabaseService.shared.toggleSelectedSeat(
                movieID: state.movie.movieId,
                seatNumber: seatNumber,
            )
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
    }

    enum Mutation {
        case startListening
        case selectSeat(Int)
    }

    struct State {
        var movie: Movie
        var selectedSeats = [SeatItem]()
    }
}
