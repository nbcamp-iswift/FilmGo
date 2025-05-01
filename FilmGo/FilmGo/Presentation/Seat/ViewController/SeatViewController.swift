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

    func setBindings() {}
}
