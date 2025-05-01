//
//  DIContainer.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import Foundation

final class DIContainer: DIContainerProtocol {
    func makeLoginViewModel() -> LoginViewModel {
        let repository = DefaultUserRepository(storage: CoreDataStorage.shared)
        let useCase = UserUseCase(repository: repository)
        return LoginViewModel(useCase: useCase)
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        let repository = DefaultUserRepository(storage: CoreDataStorage.shared)
        let useCase = UserUseCase(repository: repository)
        return SignUpViewModel(useCase: useCase)
    }

    func makeHomeViewModel() -> HomeViewModel {
        let repository = DefaultMovieRepository(
            networkService: DefaultNetworkService(),
            imageCacheService: ImageCacheService.shared,
            storage: CoreDataStorage.shared,
        )
        let useCase = MovieUseCase(repository: repository)
        return HomeViewModel(useCase: useCase)
    }

    func makeSearchViewModel() -> SearchViewModel {
        let repository = DefaultMovieRepository(
            networkService: DefaultNetworkService(),
            imageCacheService: ImageCacheService.shared,
            storage: CoreDataStorage.shared,
        )
        let useCase = MovieUseCase(repository: repository)
        return SearchViewModel(useCase: useCase)
    }

    func makeMyPageViewModel() -> MyPageViewModel {
        let repository = DefaultUserRepository(storage: CoreDataStorage.shared)
        let useCase = UserUseCase(repository: repository)
        return MyPageViewModel(useCase: useCase)
    }

    func makeDetailViewModel(movie: Movie) -> DetailViewModel {
        DetailViewModel(movie: movie)
    }

    func makeOrderViewModel(movie: Movie) -> OrderViewModel {
        OrderViewModel(movie: movie)
    }

    func makeSeatViewModel(movie: Movie) -> SeatViewModel {
        let repository = DefaultOrderRepository(storage: CoreDataStorage.shared)
        let useCase = OrderUseCase(repository: repository)
        return SeatViewModel(movie: movie, useCase: useCase)
    }
}
