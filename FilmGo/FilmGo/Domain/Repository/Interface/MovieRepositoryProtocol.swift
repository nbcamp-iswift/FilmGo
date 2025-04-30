import Foundation
import RxSwift

protocol MovieRepositoryProtocol {
    func fetchNowPlayingMovies(page: Int) -> Single<PaginatedMovies>
    func fetchPopularMovies(page: Int) -> Single<PaginatedMovies>
    func fetchMovieEntity(id: Int) -> Single<Movie>
}
