//
//  FGButton.swift
//  FilmGo
//
//  Created by youseokhwan on 4/26/25.
//

import UIKit

final class FGButton: UIButton {
    enum FGButtonType: String {
        case login = "로그인"
        case signUp = "회원가입"
        case book = "예매하기"
        case selectSeat = "좌석 선택하기"
        case pay = "결제하기"
    }

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
    }

    func setAttributes() {
        layer.cornerRadius = 6
        clipsToBounds = true

        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }

            var config = button.configuration
            config?.attributedTitle = .init(
                fgButtonType.rawValue,
                attributes: .init([
                    .foregroundColor: baseForegroundColor,
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ])
            )
            config?.background.backgroundColorTransformer = .init { _ in
                self.baseBackgroundColor
            }

            button.configuration = config
        }
    }
}
