//
//  TabBarCoordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

final class TabBarCoordinator {
    private let parentCoordinator: AppCoordinator
    private let tabBarController = UITabBarController()
    private var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(
        parentCoordinator: AppCoordinator,
        navigationController: UINavigationController,
        diContainer: DIContainerProtocol
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        let pages: [TabBarType] = TabBarType.allCases
        let tabBarItems: [UITabBarItem] = pages.map { createTabBarItem(type: $0) }
        let controllers: [UINavigationController] = tabBarItems.map {
            createNavigationController(tabBarItem: $0)
        }

        controllers.forEach {
            startCoordinator(navigationController: $0)
        }

        configureViewControllers(navigationControllers: controllers)
        setTabBarController()
    }

    private func createTabBarItem(type: TabBarType) -> UITabBarItem {
        UITabBarItem(
            title: type.title,
            image: type.image,
            tag: type.index
        )
    }

    private func createNavigationController(tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }

    private func startCoordinator(navigationController: UINavigationController) {
        let tabBarItemTag = navigationController.tabBarItem.tag
        guard let tabBarType = TabBarType(index: tabBarItemTag) else {
            return
        }

        switch tabBarType {
        case .home:
            let homeCoordinator = HomeCoordinator(
                navigationController: navigationController,
                diConatiner: diContainer
            )
            homeCoordinator.start()
        case .search:
            let searchCoordinator = SearchCoordinator(
                navigationController: navigationController,
                diConatiner: diContainer
            )
            searchCoordinator.start()
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(
                parentCoordinator: parentCoordinator,
                navigationController: navigationController,
                diConatiner: diContainer
            )
            myPageCoordinator.start()
        }
    }

    private func configureViewControllers(navigationControllers: [UINavigationController]) {
        tabBarController.setViewControllers(navigationControllers, animated: false)
        tabBarController.selectedIndex = TabBarType.home.index
        tabBarController.tabBar.tintColor = .primary500
        tabBarController.tabBar.unselectedItemTintColor = .gray

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .baseBlack

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
    }

    private func setTabBarController() {
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
