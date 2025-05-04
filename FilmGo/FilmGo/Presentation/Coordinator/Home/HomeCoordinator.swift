//
//  HomeCoordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(navigationController: UINavigationController, diConatiner: DIContainerProtocol) {
        self.navigationController = navigationController
        diContainer = diConatiner
    }

    func start() {
        showHomeView()
    }
}

extension HomeCoordinator {
    func showHomeView() {
        let homeVC = HomeViewController(
            viewModel: diContainer.makeHomeViewModel(),
            coordinator: self
        )
        navigationController.pushViewController(homeVC, animated: true)
    }

    func showDetailView(movie: Movie) {
        let detailVC = DetailViewController(
            viewModel: diContainer.makeDetailViewModel(movie: movie),
            coordinator: self
        )
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showOrderView(movie: Movie) {
        let orderVC = OrderViewController(
            viewModel: diContainer.makeOrderViewModel(movie: movie),
            coordinator: self
        )
        navigationController.pushViewController(orderVC, animated: true)
    }

    func showSeatView(movie: Movie) {
        let seatVC = SeatViewController(
            viewModel: diContainer.makeSeatViewModel(movie: movie)
        )
        navigationController.pushViewController(seatVC, animated: true)
    }
}
