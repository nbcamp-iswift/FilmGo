//
//  OrderViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class OrderViewController: UIViewController {
    private var coordinator: HomeCoordinator

    private let viewModel: OrderViewModel
    private let disposeBag = DisposeBag()

    private let orderView = OrderView()

    init(viewModel: OrderViewModel, coordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = orderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.applyFGNavigationBarStyle(.dark(title: "예매하기"))
    }
}

private extension OrderViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        orderView.didTapCell
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] indexPath in
                switch indexPath.section {
                case 0:
                    self?.viewModel.action.accept(.selectDate(indexPath.item))
                case 1:
                    self?.viewModel.action.accept(.selectTime(indexPath.item))
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        orderView.didTapSelectSeatButton
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                guard let movie = self?.viewModel.state.value.movie else { return }
                self?.coordinator.showSeatView(movie: movie)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.movie)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] movie in
                self?.orderView.updateLayout(with: movie)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.movie)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] movie in
                self?.orderView.updateLayout(with: movie)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.selectedDateIndex)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] index in
                self?.orderView.updateSelectedDate(at: index)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.selectedTimeIndex)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] index in
                self?.orderView.updateSelectedTime(at: index)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .compactMap(\.selectSeatButtonIsEnabled)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] isEnabled in
                self?.orderView.updateSelectSeatButtonIsEnabled(isEnabled)
            }
            .disposed(by: disposeBag)
    }
}
