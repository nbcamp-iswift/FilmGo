//
//  FGTextField.swift
//  FilmGo
//
//  Created by 곽다은 on 4/27/25.
//

import UIKit
import SnapKit

final class FGTextField: UIStackView {
    private let type: TextFieldType

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals100
        label.font = .systemFont(ofSize: 11.9)
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .baseWhite
        textField.backgroundColor = .neutrals600
        textField.layer.cornerRadius = 6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        textField.leftViewMode = .always
        return textField
    }()

    private let eyeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(.eye, for: .normal)
        button.setImage(.eye, for: .selected) // TODO: slash eye 추가
        button.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 15),
            forImageIn: .normal
        )
        button.tintColor = .neutrals200
        button.configuration?.baseBackgroundColor = .clear
        return button
    }()

    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
}

private extension FGTextField {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        axis = .vertical
        spacing = 4
        titleLabel.text = type.title
        setPlaceholder()
        setTextFieldRightView()
    }

    func setHierarchy() {
        [
            titleLabel,
            textField,
        ].forEach { addArrangedSubview($0) }
    }

    func setConstraints() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    func setPlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(
            string: type.placeholder,
            attributes: [
                .foregroundColor: UIColor.neutrals400,
                .font: UIFont.systemFont(ofSize: 16),
            ]
        )
    }

    func setTextFieldRightView() {
        let isPasswordType = type == .password || type == .confirmPassword
        textField.isSecureTextEntry = isPasswordType
        textField.rightView = isPasswordType
            ? eyeButton
            : UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        textField.rightViewMode = .always
    }
}

extension FGTextField {
    enum TextFieldType {
        case email
        case name
        case password
        case confirmPassword
        case search

        var title: String? {
            switch self {
            case .email:
                return "이메일"
            case .name:
                return "이름"
            case .password:
                return "비밀번호"
            case .confirmPassword:
                return "비밀번호 확인"
            case .search:
                return nil
            }
        }

        var placeholder: String {
            switch self {
            case .email:
                return "이메일 주소를 입력하세요"
            case .name:
                return "이름을 입력하세요"
            case .password:
                return "비밀번호를 입력하세요"
            case .confirmPassword:
                return "비밀번호를 다시 입력하세요"
            case .search:
                return "영화 제목, 배우, 감독을 검색하세요"
            }
        }
    }
}
