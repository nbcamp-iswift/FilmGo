//
//  OrderCell.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit
import SnapKit

final class OrderCell: UICollectionViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let infoView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 13.6)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 11.9)
        return label
    }()

    private let seatsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 11.9)
        return label
    }()

    private let orderStateView = OrderStateView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with order: Order) {
        posterImageView.backgroundColor = .primary300
        // TODO: posterImageView.setProgressiveImage(by:)로 변경
        titleLabel.text = ""
        dateLabel.text = "2024-01-15 20:00"
        seatsLabel.text = "좌석: D4, D5"
        orderStateView.update(state: .upComming)
    }
}

private extension OrderCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .neutrals800
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    func setHierarchy() {
        [
            posterImageView,
            infoView,
            orderStateView,
        ].forEach { addSubview($0) }

        [
            titleLabel,
            dateLabel,
            seatsLabel,
        ].forEach { infoView.addSubview($0) }
    }

    func setConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(96)
            make.height.equalTo(144)
        }

        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18.5)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.greaterThanOrEqualTo(orderStateView.snp.leading).offset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        seatsLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
        }

        orderStateView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }
    }
}
