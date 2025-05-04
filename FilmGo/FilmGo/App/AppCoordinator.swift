//
//  AppCoordinator.swift
//  FilmGo
//
//  Created by 곽다은 on 4/30/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol
    private var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        diContainer = DIContainer()
        configure()
    }

    func start() {
        if CoreDataStorage.shared.fetchLoggedInUser() != nil {
            runTabFlow()
        } else {
            runLoginFlow()
        }
    }
}

private extension AppCoordinator {
    func configure() {
        setAttributes()
    }

    func setAttributes() {
        navigationController.navigationBar.isHidden = true
    }
}

extension AppCoordinator {
    func runTabFlow() {
        navigationController.viewControllers = []
        let tabbarCoordinator = TabBarCoordinator(
            parentCoordinator: self,
            navigationController: navigationController,
            diContainer: diContainer
        )
        childCoordinators.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }

    func runLoginFlow() {
        navigationController.viewControllers = []
        let loginCoordinator = LoginCoordinator(
            parentCoordinator: self,
            navigationController: navigationController,
            diContainer: diContainer
        )
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}

extension AppCoordinator {
    func logout() {
        childCoordinators.removeAll()
        runLoginFlow()
    }

    func login(coordinator: LoginCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        runTabFlow()
    }
}
