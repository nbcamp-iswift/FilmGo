//
//  UserView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit
import SnapKit

final class UserView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()

    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 13.6)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}

private extension UserView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .neutrals800
    }

    func setHierarchy() {
        [
            profileImageView,
            userInfoStackView,
        ].forEach { addSubview($0) }

        [
            nameLabel,
            emailLabel,
        ].forEach { userInfoStackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.bottom.equalToSuperview().inset(24)
            make.size.equalTo(64)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView)
        }
    }
}
