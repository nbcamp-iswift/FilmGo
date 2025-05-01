import UIKit
import RxSwift

final class DefaultMovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    private let storage: CoreDataStorage

    init(
        networkService: NetworkServiceProtocol,
        imageCacheService: ImageCacheServiceProtocol,
        storage: CoreDataStorage
    ) {
        self.networkService = networkService
        self.imageCacheService = imageCacheService
        self.storage = storage
    }
}

// MARK: - Network

extension DefaultMovieRepository {
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
            .map { detailDto, creditDto in
                self.mapToMovieEntity(
                    detailDTO: detailDto,
                    creditDTO: creditDto
                ) }
    }

    func fetchPopularMovies(page: Int) -> Single<PaginatedMovies> {
        fetchMovieList(page: page, endPoint: .popular)
    }

    func fetchNowPlayingMovies(page: Int) -> Single<PaginatedMovies> {
        fetchMovieList(page: page, endPoint: .nowPlaying)
    }

    private func mapToMovieEntity(
        detailDTO: MovieDetailResponseDTO,
        creditDTO: MovieCreditResponseDTO,
    ) -> Movie {
        let releaseYear = detailDTO.releaseDate?
            .split(separator: "-")
            .first
            .flatMap { Int($0) } ?? 0

        let genres = detailDTO.genres?.compactMap(\.name) ?? []
        let voteAverage = String(format: "%.1f", detailDTO.voteAverage ?? 0)

        return Movie(
            movieId: detailDTO.id ?? 0,
            posterImagePath: detailDTO.posterPath ?? "",
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
                    .do(onSuccess: { [weak self] movies in
                        self?.storage.saveMovies(movies)
                    })
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

// MARK: - ImageCacheService

extension DefaultMovieRepository {
    func fetchPosterImage(
        for movie: Movie,
        size: TMDBPosterSize = .w500
    ) -> Single<UIImage?> {
        guard !movie.posterImagePath.isEmpty else {
            return .just(nil)
        }

        return imageCacheService.loadImage(
            path: movie.posterImagePath,
            size: size,
            option: .memory,
            type: .network
        ) { path, size in
            self.networkService.downloadImage(path: path, size: size)
        }
        .map { UIImage(data: $0) }
    }

    func fetchPosterProgressiveImage(
        for movie: Movie
    ) -> Observable<UIImage?> {
        guard !movie.posterImagePath.isEmpty else {
            return .just(nil)
        }

        return imageCacheService.loadProgressiveImage(
            path: movie.posterImagePath,
            lowResSize: .w92,
            highResSize: .original,
            delay: .microseconds(400)
        ) { path, size in
            self.networkService.downloadImage(path: path, size: size)
        }
        .map { UIImage(data: $0) }
    }
}

// MARK: - Core Data

extension DefaultMovieRepository {
    func fetchMoviesByTitle(movieTitle: String) -> [Movie] {
        storage.searchMovie(movieTitle: movieTitle)
    }

    func updateMovieImageData(movieId: Int, imageData: Data) {
        storage.saveMovieImage(id: movieId, imageData: imageData)
    }
}
