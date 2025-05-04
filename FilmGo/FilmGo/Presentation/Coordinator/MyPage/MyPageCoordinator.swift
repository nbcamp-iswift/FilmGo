//
//  MyPageCoordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    private weak var parentCoordinator: TabBarCoordinator?
    var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(
        parentCoordinator: TabBarCoordinator?,
        navigationController: UINavigationController,
        diConatiner: DIContainerProtocol
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        diContainer = diConatiner
    }

    func start() {
        showMyPage()
    }

    func logout() {
        parentCoordinator?.logout()
    }
}

extension MyPageCoordinator {
    func showMyPage() {
        let myPageVC = MyPageViewController(
            coordinator: self,
            viewModel: diContainer.makeMyPageViewModel()
        )
        navigationController.pushViewController(myPageVC, animated: true)
    }
}
