import Foundation
import RxSwift

protocol MovieRepositoryProtocol {
    func fetchNowPlayingMovies(page: Int) -> Single<NowPlayingMovies>
    func fetchPopularMovies(page: Int) -> Single<PopularMovies>
    func fetchMovieEntity(id: Int) -> Single<Movie>
}
