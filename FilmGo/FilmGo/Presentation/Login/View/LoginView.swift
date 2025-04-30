//
//  LoginView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    private let formView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutrals800
        view.layer.cornerRadius = 8
        return view
    }()

    private let profileImageView: UIView = {
        let imageView = UIImageView()
        imageView.image = .profile
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 20.4)
        return label
    }()

    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let emailTextField = FGTextField(type: .email)

    private let passwordTextField = FGTextField(type: .password)

    private let loginButton = FGButton(type: .login)

    private let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4.19
        return stackView
    }()

    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없으신가요?"
        label.font = .systemFont(ofSize: 13.6)
        label.textColor = .baseWhite
        return label
    }()

    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.6)
        button.setTitleColor(.primary300, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension LoginView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .baseBlack
    }

    func setHierarchy() {
        [
            formView
        ].forEach { addSubview($0) }

        [
            profileImageView,
            titleLabel,
            textFieldStackView,
            loginButton,
            signUpStackView,
        ].forEach { formView.addSubview($0) }

        [
            emailTextField,
            passwordTextField,
        ].forEach { textFieldStackView.addArrangedSubview($0) }

        [
            signUpLabel,
            signUpButton
        ].forEach { signUpStackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        formView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
        }

        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.directionalHorizontalEdges.equalToSuperview().inset(32)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(32)
        }

        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
