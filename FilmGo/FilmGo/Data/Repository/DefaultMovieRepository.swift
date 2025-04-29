import Foundation
import RxSwift

final class DefaultMovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchMovieEntity(id: Int) -> Single<Movie> {
        let detailReq: Single<MovieDetailResponseDTO> = networkService.request(
            type: .movieDetail(movieID: id),
            queryParameters: MovieDetailRequestDTO(movieID: id)
        )

        let creditReq: Single<MovieCreditResponseDTO> = networkService.request(
            type: .movieCredit(movieID: id),
            queryParameters: MovieCreditsRequestDTO(movieID: id)
        )

        // Observable return
        return Single.zip(detailReq, creditReq)
            .flatMap { detailDto, creditDto -> Single<Movie> in
                guard let posterURL = URL(string: "") else {
                    throw NetworkError.invalidURL
                }

                return self.networkService.downloadImage(from: posterURL)
                    .map { posterData in
                        let genres = detailDto.genres.map(\.name)

                        let releasedYear: Int = {
                            let components = detailDto.releaseDate.split(separator: "-")
                            if let yearStr = components.first,
                               let year = Int(yearStr) {
                                return year
                            }
                            return 0
                        }()

                        let director: String = creditDto.crew.first(
                            where: { $0.job == "Director" })?.name ?? "Unknown"

                        let actors: [String] = creditDto.cast.prefix(3).map(\.name)
                        let runningTime = "\(detailDto.runtime)"
                        let voteAverage = (detailDto.voteAverage * 10).rounded() * 0.1

                        return Movie(
                            movieId: detailDto.id,
                            posterImage: posterData,
                            title: detailDto.title,
                            star: voteAverage,
                            runningTime: runningTime,
                            releasedYear: releasedYear,
                            genres: genres,
                            director: director,
                            actors: actors
                        )
                    }
            }
    }

    func fetchPopularMovies(page: Int) -> Single<PopularMovies> {
        let popularRequest: Single<PopularMoviesResponseDTO> = networkService.request(
            type: .popular,
            queryParameters: MoviesRequestDTO(page: page)
        )
        return popularRequest
            .flatMap { res in
                let movieSingles: [Single<MovieBrief>] = res.results
                    .map { summary in
                        guard let posterURL = URL(string: summary.posterPath) else {
                            return Single.error(NetworkError.invalidURL)
                        }

                        let detailReq: Single<MovieDetailResponseDTO> = self.networkService.request(
                            type: .movieDetail(movieID: summary.id),
                            queryParameters: MovieDetailRequestDTO(movieID: summary.id)
                        )

                        let posterReq: Single<Data> = self.networkService.downloadImage(
                            from: posterURL
                        )

                        return Single.zip(detailReq, posterReq)
                            .map { detail, posterData in
                                let genres = detail.genres.map(\.name)

                                let releaseYear: Int = {
                                    let components = detail.releaseDate.split(separator: "-")
                                    if let yearStr = components.first,
                                       let year = Int(yearStr) {
                                        return year
                                    }
                                    return 0
                                }()
                                let runningTime = "\(detail.runtime)"
                                let voteAverage = (detail.voteAverage * 10).rounded() * 0.1

                                return MovieBrief(
                                    movieId: summary.id,
                                    posterImage: posterData,
                                    title: summary.title,
                                    star: voteAverage,
                                    runningTime: runningTime,
                                    releasedYear: releaseYear,
                                    genres: genres
                                )
                            }
                    }
                return Single.zip(movieSingles)
                    .map { movies in
                        PopularMovies(
                            currentPage: res.page,
                            totalPages: res.totalPages,
                            movies: movies
                        )
                    }
            }
    }

    func fetchNowPlayingMovies(page: Int) -> Single<NowPlayingMovies> {
        let nowPlayingRequest: Single<NowPlayingMovieResponseDTO> = networkService.request(
            type: .popular,
            queryParameters: MoviesRequestDTO(page: page)
        )

        return nowPlayingRequest
            .flatMap { res in
                let movieSingles: [Single<MovieBrief>] = res.results
                    .map { summary in
                        guard let posterURL = URL(string: summary.posterPath) else {
                            return Single.error(NetworkError.invalidURL)
                        }

                        let detailReq: Single<MovieDetailResponseDTO> = self.networkService.request(
                            type: .movieDetail(movieID: summary.id),
                            queryParameters: MovieDetailRequestDTO(movieID: summary.id)
                        )

                        let posterReq: Single<Data> = self.networkService.downloadImage(
                            from: posterURL
                        )

                        return Single.zip(detailReq, posterReq)
                            .map { detail, posterData in
                                let genres = detail.genres.map(\.name)

                                let releaseYear: Int = {
                                    let components = detail.releaseDate.split(separator: "-")
                                    if let yearStr = components.first,
                                       let year = Int(yearStr) {
                                        return year
                                    }
                                    return 0
                                }()
                                let runningTime = "\(detail.runtime)"
                                let voteAverage = (detail.voteAverage * 10).rounded() * 0.1

                                return MovieBrief(
                                    movieId: summary.id,
                                    posterImage: posterData,
                                    title: summary.title,
                                    star: voteAverage,
                                    runningTime: runningTime,
                                    releasedYear: releaseYear,
                                    genres: genres
                                )
                            }
                    }
                return Single.zip(movieSingles)
                    .map { movies in
                        NowPlayingMovies(
                            currentPage: res.page,
                            totalPages: res.totalPages,
                            movies: movies
                        )
                    }
            }
    }
}
