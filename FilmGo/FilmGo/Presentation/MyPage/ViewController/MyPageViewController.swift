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
    private let viewModel: MyPageViewModel
    private var disposeBag = DisposeBag()

    private let myPageView = MyPageView()

    init(viewModel: MyPageViewModel) {
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
}

private extension MyPageViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        let logoutTapGesture = UITapGestureRecognizer()
        myPageView.logoutView.addGestureRecognizer(logoutTapGesture)

        logoutTapGesture.rx.event
            .map { _ in MyPageViewModel.Action.didTapLogout }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.isLogout)
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { _, _ in
                // TODO: popViewController, loginVC로 이동
            }
            .disposed(by: disposeBag)
    }
}
