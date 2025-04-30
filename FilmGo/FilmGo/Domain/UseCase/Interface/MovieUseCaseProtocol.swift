//
//  MovieUseCaseProtocol.swift
//  FilmGo
//
//  Created by 유현진 on 4/30/25.
//

import Foundation
import RxSwift

protocol MovieUseCaseProtocol {
    func fetchNowPlaying(page: Int) -> Observable<PaginatedMovies>
    func fetchPopular(page: Int) -> Observable<PaginatedMovies>
}
