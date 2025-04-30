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
                guard let posterPath = detailDto.posterPath else {
                    return Single.error(NetworkError.invalidURL)
                }

                return self.networkService.downloadImage(path: posterPath, size: .w500)
                    .map { posterData in
                        let movieId = detailDto.id ?? 0
                        let genres = detailDto.genres?.compactMap(\.name) ?? []
                        let releasedYear: Int = {
                            guard let releaseDate = detailDto.releaseDate else { return 0 }
                            let components = releaseDate.split(separator: "-")
                            return Int(components.first ?? "") ?? 0
                        }()

                        let director: String = creditDto.crew?
                            .first(where: { $0.job == "Director" })?
                            .name ?? ""

                        let actors: [String] = creditDto.cast?
                            .prefix(3)
                            .compactMap(\.name) ?? []

                        let runningTime = "\(detailDto.runtime ?? 0)"
                        let voteAverage = ((detailDto.voteAverage ?? 0) * 10).rounded() * 0.1
                        let title = detailDto.title ?? ""
                        let overview = detailDto.overview ?? ""

                        return Movie(
                            movieId: movieId,
                            posterImage: posterData,
                            title: title,
                            star: voteAverage,
                            runningTime: runningTime,
                            releasedYear: releasedYear,
                            genres: genres,
                            overview: overview,
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
                        guard let posterPath = summary.posterPath else {
                            return Single.error(NetworkError.invalidURL)
                        }

                        let summaryId = summary.id ?? 0
                        let detailReq: Single<MovieDetailResponseDTO> = self.networkService.request(
                            type: .movieDetail(movieID: summaryId),
                            queryParameters: MovieDetailRequestDTO(movieID: summaryId)
                        )

                        let posterReq: Single<Data> = self.networkService.downloadImage(
                            path: posterPath, size: .w500
                        )

                        return Single.zip(detailReq, posterReq)
                            .map { detail, posterData in
                                let genres = detail.genres?.compactMap(\.name) ?? []

                                let releaseYear: Int = {
                                    guard let releaseDate = detail.releaseDate else { return 0 }
                                    let components = releaseDate.split(separator: "-")
                                    return Int(components.first ?? "") ?? 0
                                }()

                                let runningTime = "\(detail.runtime ?? 0)"
                                let voteAverage = ((detail.voteAverage ?? 0) * 10).rounded() * 0.1

                                let summaryTitle = summary.title ?? "No Title"

                                return MovieBrief(
                                    movieId: summaryId,
                                    posterImage: posterData,
                                    title: summaryTitle,
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
                        guard let posterPath = summary.posterPath else {
                            return Single.error(NetworkError.invalidURL)
                        }

                        let summaryId = summary.id ?? 0

                        let detailReq: Single<MovieDetailResponseDTO> = self.networkService.request(
                            type: .movieDetail(movieID: summaryId),
                            queryParameters: MovieDetailRequestDTO(movieID: summaryId)
                        )

                        let posterReq: Single<Data> = self.networkService.downloadImage(
                            path: posterPath, size: .w500
                        )

                        return Single.zip(detailReq, posterReq)
                            .map { detail, posterData in
                                let genres = detail.genres?.compactMap(\.name) ?? []

                                let releaseYear: Int = {
                                    guard let releaseDate = detail.releaseDate else { return 0 }
                                    let components = releaseDate.split(separator: "-")
                                    return Int(components.first ?? "") ?? 0
                                }()

                                let runningTime = "\(detail.runtime ?? 0)"
                                let voteAverage = ((detail.voteAverage ?? 0) * 10).rounded() * 0.1
                                let summaryTitle = summary.title ?? "No Title"

                                return MovieBrief(
                                    movieId: summaryId,
                                    posterImage: posterData,
                                    title: summaryTitle,
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
