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

        return Single.zip(detailReq, creditReq)
            .flatMap { detailDto, creditDto -> Single<Movie> in
                guard let posterPath = detailDto.posterPath else {
                    return Single.error(NetworkError.invalidURL)
                }

                return self.networkService.downloadImage(path: posterPath, size: .w500)
                    .map { imageData in
                        self.mapToMovieEntity(
                            detailDTO: detailDto,
                            creditDTO: creditDto,
                            imageData: imageData
                        )
                    }
            }
    }

    func fetchPopularMovies(page: Int) -> Single<PaginatedMovies> {
        fetchMovieList(
            page: page,
            endPoint: .popular
        )
    }

    func fetchNowPlayingMovies(page: Int) -> Single<PaginatedMovies> {
        fetchMovieList(
            page: page,
            endPoint: .nowPlaying
        )
    }

    private func mapToMovieEntity(
        detailDTO: MovieDetailResponseDTO,
        creditDTO: MovieCreditResponseDTO,
        imageData: Data
    ) -> Movie {
        let releaseYear = detailDTO.releaseDate?.split(separator: "-").first
            .flatMap { Int($0) } ?? 0

        let genres = detailDTO.genres?.compactMap(\.name) ?? []
        let voteAverage = String(format: "%.1f", detailDTO.voteAverage ?? 0)

        return Movie(
            movieId: detailDTO.id ?? 0,
            posterImage: imageData,
            title: detailDTO.title ?? "Untitled",
            star: voteAverage,
            runningTime: "\(detailDTO.runtime ?? 0)",
            releasedYear: releaseYear,
            genres: genres,
            overview: detailDTO.overview ?? "",
            director: creditDTO.crew?.first?.name ?? "",
            actors: creditDTO.cast?.prefix(3).compactMap(\.name) ?? []
        )
    }

    private func fetchMovieList(
        page: Int,
        endPoint: NetworkServiceType
    ) -> Single<PaginatedMovies> {
        let request: Single<NowPlayingPopularMovieResponseDTO> = networkService.request(
            type: endPoint,
            queryParameters: MoviesRequestDTO(page: page)
        )

        return request
            .flatMap { res in
                let movieSingles: [Single<Movie>] = res.results
                    .compactMap(\.id)
                    .map { self.fetchMovieEntity(id: $0) }

                return Single.zip(movieSingles)
                    .map { movies in
                        PaginatedMovies(
                            currentPage: res.page,
                            totalPages: res.totalPages,
                            movies: movies
                        )
                    }
            }
    }
}
