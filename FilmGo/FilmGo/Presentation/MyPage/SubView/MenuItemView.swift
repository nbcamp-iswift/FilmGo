//
//  MenuItemView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit
import SnapKit

final class MenuItemView: UIView {
    private let type: MenuType

    private let symbolImageView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        label.font = .systemFont(ofSize: 13.6)
        return label
    }()

    init(type: MenuType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension MenuItemView {
    func configure() {
        setAttributes()
        setHierachy()
        setConstraints()
    }

    func setAttributes() {
        symbolImageView.image = type.symbol
        titleLabel.text = type.rawValue
        backgroundColor = .neutrals800
    }

    func setHierachy() {
        [
            symbolImageView,
            titleLabel,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        symbolImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(symbolImageView)
        }
    }
}

enum MenuType: String {
    case orderHistory = "전체 예매 내역"
    case logout = "로그아웃"

    var symbol: UIImage {
        switch self {
        case .orderHistory:
            return .ticket
        case .logout:
            return .logout
        }
    }
}
