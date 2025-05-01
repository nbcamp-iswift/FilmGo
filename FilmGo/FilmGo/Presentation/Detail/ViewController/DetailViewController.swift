//
//  DetailViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private var coordinator: HomeCoordinator
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()

    private let detailView = DetailView()

    init(viewModel: DetailViewModel, coordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.applyFGNavigationBarStyle(.clear)
        navigationItem.backButtonTitle = nil
    }
}

extension DetailViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.state
            .compactMap(\.movie)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] in
                self?.detailView.update(with: $0)
            }
            .disposed(by: disposeBag)

        detailView.didTapbookButton
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                guard let movie = self?.viewModel.state.value.movie else { return }
                self?.coordinator.showOrderView(movie: movie)
            }
            .disposed(by: disposeBag)
    }
}
