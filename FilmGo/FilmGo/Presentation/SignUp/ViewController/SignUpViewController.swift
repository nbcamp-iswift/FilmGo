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
}

private extension SignUpViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        signUpView.signUpButton.rx.tap
            .map { SignUpViewModel.Action.didTapSignUpButton }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isSignUp)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { _, _ in
            }
            .disposed(by: disposeBag)
    }
}
