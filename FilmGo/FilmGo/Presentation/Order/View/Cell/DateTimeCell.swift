//
//  DateTimeCell.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

final class DateTimeCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.textColor = .neutrals100
        label.font = .systemFont(ofSize: 11.9)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateLabel(_ text: String) {
        label.text = text
    }

    func updateIsSelected(_ value: Bool) {
        backgroundColor = value ? .primary300 : .neutrals600
        label.textColor = value ? .neutrals600 : .neutrals100
    }
}

private extension DateTimeCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .neutrals600
        layer.cornerRadius = 8
    }

    func setHierarchy() {
        contentView.addSubview(label)
    }

    func setConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
