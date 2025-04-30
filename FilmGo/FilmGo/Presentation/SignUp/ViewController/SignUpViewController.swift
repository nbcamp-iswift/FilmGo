//
//  SignUpViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    let viewModel: SignUpViewModel
    let disposeBag = DisposeBag()
    private let signUpView = SignUpView()

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

private extension SignUpViewController {
    func configure() {
        setBindings()
        dismissKeyboard()
    }

    func setBindings() {
        signUpView.backButton.rx.tap
            .map { SignUpViewModel.Action.didTapBackButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.emailTextField.textField.rx.text
            .orEmpty
            .map { SignUpViewModel.Action.didChangeEmailTextField($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.nameTextField.textField.rx.text
            .orEmpty
            .map { SignUpViewModel.Action.didChangeNameTextField($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.passwordTextField.textField.rx.text
            .orEmpty
            .map { SignUpViewModel.Action.didChangePasswordTextField($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.confirmPasswordTextField.textField.rx.text
            .orEmpty
            .map { SignUpViewModel.Action.didChangeConfirmPasswordTextField($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.signUpButton.rx.tap
            .map { SignUpViewModel.Action.didTapSignUpButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        signUpView.loginButton.rx.tap
            .map { SignUpViewModel.Action.didTapLoginButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.backToLogin)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: false)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isEnabledSignUp)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isEnabled in
                owner.signUpView.signUpButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isSignUp)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { _, _ in
            }
            .disposed(by: disposeBag)
    }

    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(addDismissKeyboardGesture)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func addDismissKeyboardGesture() {
        view.endEditing(true)
    }
}
