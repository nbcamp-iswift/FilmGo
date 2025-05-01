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
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()

    private let detailView = DetailView()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
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
}

extension DetailViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.action.accept(.fetchMovie)

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
                // TODO: DIContainer 구현하기 전 임시 push
                let vc = OrderViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
