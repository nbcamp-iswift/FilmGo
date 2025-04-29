//
//  SignUpViewController.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit

final class SignUpViewController: UIViewController {
    private let signUpView = SignUpView()

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
