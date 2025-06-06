//
//  LoginViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    let viewModel: LoginViewModel
    weak var coordinator: LoginCoordinator?
    let disposeBag = DisposeBag()

    private let loginView = LoginView()

    init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension LoginViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        loginView.loginButton.rx.tap
            .map { LoginViewModel.Action.didTapLoginButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        loginView.emailTextField.textField.rx.text
            .orEmpty
            .map { LoginViewModel.Action.didChangeEmailTextField($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        loginView.passwordTextField.textField.rx.text
            .orEmpty
            .map { LoginViewModel.Action.didChangePasswordTextFiedl($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        loginView.signUpButton.rx.tap
            .map { LoginViewModel.Action.didTapSignUpButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isEnabledLogin)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isEnabled in
                owner.loginView.loginButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isLogin)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.coordinator?.login()
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.pushSignUpVC)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.coordinator?.showSignUpView()
            }
            .disposed(by: disposeBag)
    }
}
