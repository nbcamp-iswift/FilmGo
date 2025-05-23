//
//  SearchCoordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(navigationController: UINavigationController, diConatiner: DIContainerProtocol) {
        self.navigationController = navigationController
        diContainer = diConatiner
    }

    func start() {
        showSearchView()
    }
}

extension SearchCoordinator {
    func showSearchView() {
        let searchVC = SearchViewController(
            viewModel: diContainer.makeSearchViewModel(),
            coordinator: self
        )
        navigationController.pushViewController(searchVC, animated: true)
    }

    func showDetailView(movie: Movie) {
        let detailVC = DetailViewController(
            viewModel: diContainer.makeDetailViewModel(movie: movie)
        )
        navigationController.pushViewController(detailVC, animated: true)
    }
}
