//
//  MyPageViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private weak var coordinator: MyPageCoordinator?
    private let viewModel: MyPageViewModel
    private var disposeBag = DisposeBag()

    private let myPageView = MyPageView()

    init(coordinator: MyPageCoordinator, viewModel: MyPageViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.accept(.viewWillAppear)
    }
}

private extension MyPageViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        let logoutTapGesture = UITapGestureRecognizer()
        myPageView.logoutView.addGestureRecognizer(logoutTapGesture)

        viewModel.action.accept(.viewDidLoad)

        logoutTapGesture.rx.event
            .map { _ in MyPageViewModel.Action.didTapLogout }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.user)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, user in
                owner.myPageView.userView.nameLabel.text = user.name
                owner.myPageView.userView.emailLabel.text = user.email
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.orders)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, orders in
                owner.myPageView.updateSnapshot(with: orders)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isLogout)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.coordinator?.logout()
            }
            .disposed(by: disposeBag)
    }
}
