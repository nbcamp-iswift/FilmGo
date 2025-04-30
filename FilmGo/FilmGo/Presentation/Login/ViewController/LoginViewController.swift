//
//  LoginViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit

final class LoginViewController: UIViewController {
    private let loginView = LoginView()

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
