//
//  OrderStateView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit
import SnapKit

final class OrderStateView: UIView {
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        label.font = .systemFont(ofSize: 11.9)
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

    func update(state: State) {
        stateLabel.text = state.rawValue
        backgroundColor = state.backgroundColor
    }
}

private extension OrderStateView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        layer.cornerRadius = 4
    }

    func setHierarchy() {
        [
            stateLabel,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        stateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.directionalHorizontalEdges.equalToSuperview().inset(8)
        }
    }
}

extension OrderStateView {
    enum State: String {
        case upComming = "예정"
        case completed = "완료"

        var backgroundColor: UIColor {
            switch self {
            case .upComming:
                return .primary500
            case .completed:
                return .neutrals400
            }
        }
    }
}
