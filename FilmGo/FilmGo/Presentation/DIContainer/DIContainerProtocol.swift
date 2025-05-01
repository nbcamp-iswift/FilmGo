//
//  DIContainerProtocol.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import Foundation

protocol DIContainerProtocol {
    func makeHomeViewModel() -> HomeViewModel
    func makeSearchViewModel() -> SearchViewModel
    func makeMyPageViewModel() -> MyPageViewModel
    func makeDetailViewModel(movie: Movie) -> DetailViewModel
    func makeOrderViewModel(movie: Movie) -> OrderViewModel
    func makeSeatViewModel(movie: Movie) -> SeatViewModel
}
