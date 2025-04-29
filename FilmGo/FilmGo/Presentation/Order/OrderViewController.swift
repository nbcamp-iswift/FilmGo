//
//  OrderViewController.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

final class OrderViewController: UIViewController {
    private let orderView = OrderView()

    override func loadView() {
        view = orderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension OrderViewController {
    func configure() {}
}
