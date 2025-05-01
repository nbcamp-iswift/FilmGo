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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .startListening:
            SupabaseService.shared.startListening(for: state.movie.movieId)
            SupabaseService.shared.selectedSeats
                .subscribe(onNext: { [weak self] seats in
                    guard let self else { return }
                    self.state.accept(.init(movie: state.movie, selectedSeats: seats))
                })
                .disposed(by: disposeBag)
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
    }

    enum Mutation {
        case startListening
    }

    struct State {
        var movie: Movie
        var selectedSeats = [Int]()
    }
}
