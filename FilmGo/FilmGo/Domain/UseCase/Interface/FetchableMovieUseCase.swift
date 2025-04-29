//
//  FetchableMovieUseCase.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import Foundation
import RxSwift

protocol FetchableMovieUseCase {
    func execute(for id: Int) -> Observable<Movie>
}
