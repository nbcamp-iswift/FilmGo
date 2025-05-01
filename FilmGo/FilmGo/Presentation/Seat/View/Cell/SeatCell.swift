//
//  SeatCell.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

final class SeatCell: UICollectionViewCell {
    private var state: SeatItem.State = .selectable

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateLayout(for state: SeatItem.State) {
        switch state {
        case .selectable:
            backgroundColor = .neutrals200
        case .alreadySelected:
            backgroundColor = .neutrals600
        case .selecting:
            backgroundColor = .primary300
        }
        isUserInteractionEnabled = state != .alreadySelected
    }
}

private extension SeatCell {
    func configure() {
        setAttributes()
    }

    func setAttributes() {
        layer.cornerRadius = 4
    }
}
