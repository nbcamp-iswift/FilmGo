//
//  MyPageViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension MyPageViewController {
    func configure() {}
}
