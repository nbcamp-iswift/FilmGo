//
//  AppCoordinator.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        diContainer = DIContainer()
    }

    func start() {
        if CoreDataStorage.shared.fetchLoggedInUser() != nil {
            runTabFlow()
        } else {
            runLoginFlow()
        }
    }
}

extension AppCoordinator {
    func runTabFlow() {
        navigationController.viewControllers = []
        let tabbarCoordinator = TabBarCoordinator(
            parentCoordinator: self,
            navigationController: navigationController,
            diContainer: diContainer,
        )
        tabbarCoordinator.start()
    }

    func runLoginFlow() {
        navigationController.viewControllers = []
        let loginCoordinator = LoginCoordinator(
            parentCoordinator: self,
            navigationController: navigationController,
            diContainer: diContainer,
        )
        loginCoordinator.start()
    }
}
