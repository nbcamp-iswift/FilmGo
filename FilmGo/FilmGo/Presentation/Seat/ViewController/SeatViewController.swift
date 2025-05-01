//
//  SeatViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SeatViewController: UIViewController {
    private let viewModel: SeatViewModel
    private let disposeBag = DisposeBag()

    private let seatView = SeatView()

    init(viewModel: SeatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = seatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.applyFGNavigationBarStyle(.dark(title: "좌석 선택"))
    }
}

extension SeatViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.action.accept(.viewDidLoad)

        viewModel.state
            .compactMap(\.selectedSeats)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] seats in
                self?.seatView.updateSelectedSeats(seats)
            }
            .disposed(by: disposeBag)

        seatView.didTapCell
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] indexPath in
                self?.viewModel.action.accept(.didTapCell(indexPath.item))
            }
            .disposed(by: disposeBag)
    }
}
