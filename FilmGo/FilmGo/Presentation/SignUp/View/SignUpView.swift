//
//  SignUpView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import SnapKit

final class SignUpView: UIView {
    private let formView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutrals800
        view.layer.cornerRadius = 8
        return view
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.back, for: .normal)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
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

    private let nameTextField = FGTextField(type: .name)

    private let passwordTextField = FGTextField(type: .password)

    private let confirmPasswordTextField = FGTextField(type: .confirmPassword)

    let signUpButton = FGButton(type: .signUp)

    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4.19
        return stackView
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 계정이 있으신가요?"
        label.font = .systemFont(ofSize: 13.6)
        label.textColor = .baseWhite
        return label
    }()

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
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

private extension SignUpView {
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
            backButton,
            titleLabel,
            textFieldStackView,
            signUpButton,
            loginStackView,
        ].forEach { formView.addSubview($0) }

        [
            emailTextField,
            nameTextField,
            passwordTextField,
            confirmPasswordTextField,
        ].forEach { textFieldStackView.addArrangedSubview($0) }

        [
            loginLabel,
            loginButton,
        ].forEach { loginStackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        formView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.leading.equalToSuperview().inset(32)
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(32)
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(32)
        }

        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
