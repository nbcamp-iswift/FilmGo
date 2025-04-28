//
//  FGButton.swift
//  FilmGo
//
//  Created by youseokhwan on 4/26/25.
//

import UIKit

final class FGButton: UIButton {
    private let fgButtonType: FGButtonType

    private var baseBackgroundColor: UIColor {
        switch state {
        case .disabled:
            return .neutrals600
        default:
            return .primary500
        }
    }

    private var baseForegroundColor: UIColor {
        switch state {
        case .disabled:
            return .neutrals400
        default:
            return .baseWhite
        }
    }

    init(type: FGButtonType) {
        fgButtonType = type
        super.init(frame: .zero)
        configuration = .filled()
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension FGButton {
    func configure() {
        setAttributes()
        setConstraints()
    }

    func setAttributes() {
        layer.cornerRadius = 6
        clipsToBounds = true

        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }

            var config = button.configuration
            config?.attributedTitle = .init(
                fgButtonType.text,
                attributes: .init([
                    .foregroundColor: baseForegroundColor,
                    .font: UIFont.boldSystemFont(ofSize: 13.6),
                ])
            )
            config?.background.backgroundColorTransformer = .init { _ in
                self.baseBackgroundColor
            }

            button.configuration = config
        }
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}

extension FGButton {
    enum FGButtonType {
        case login
        case signUp
        case book
        case selectSeat
        case pay

        var text: String {
            switch self {
            case .login:
                return "로그인"
            case .signUp:
                return "회원가입"
            case .book:
                return "예매하기"
            case .selectSeat:
                return "좌석 선택하기"
            case .pay:
                return "결제하기"
            }
        }
    }
}
