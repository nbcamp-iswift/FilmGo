//
//  MyPageCoordinator.swift
//  FilmGo
//
//  Created by 유현진 on 5/1/25.
//

import UIKit

final class MyPageCoordinator {
    // TODO: Add AppCoordinator
    private var navigationController: UINavigationController
    private let diContainer: DIContainerProtocol

    init(navigationController: UINavigationController, diConatiner: DIContainerProtocol) {
        self.navigationController = navigationController
        diContainer = diConatiner
    }

    func start() {
        showMyPage()
    }
}

extension MyPageCoordinator {
    func showMyPage() {
        let myPageVC = MyPageViewController(viewModel: diContainer.makeMyPageViewModel())
        navigationController.pushViewController(myPageVC, animated: true)
    }
}
