//
//  LoginCoordinator.swift
//  FilmGo
//
//  Created by 곽다은 on 5/1/25.
//

import UIKit

final class LoginCoordinator {
    var parentCoordinator: AppCoordinator
    private var navigationController: UINavigationController
    private var diContainer: DIContainerProtocol

    init(
        parentCoordinator: AppCoordinator,
        navigationController: UINavigationController,
        diContainer: DIContainerProtocol,
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        showLoginView()
    }

    func login() {
        parentCoordinator.runTabFlow()
    }
}

extension LoginCoordinator {
    func showLoginView() {
        let loginVC = LoginViewController(
            viewModel: diContainer.makeLoginViewModel(),
            coordinator: self,
        )
        navigationController.pushViewController(loginVC, animated: true)
    }

    func showSignUpView() {
        let signUpVC = SignUpViewController(viewModel: diContainer.makeSignUpViewModel())
        navigationController.pushViewController(signUpVC, animated: false)
    }
}
