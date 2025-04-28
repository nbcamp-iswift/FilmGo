//
//  InfoStackView.swift
//  FilmGo
//
//  Created by 유현진 on 4/28/25.
//

import UIKit
import SnapKit

final class InfoStackView: UIStackView {
    enum InfoType {
        case item
        case detail
    }

    private let infoType: InfoType

    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        return imageView
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        return label
    }()

    private let runtimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()

    private let runtimeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "runtime")
        return imageView
    }()

    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals200
        return label
    }()

    private let releasedYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 13.6)
        return label
    }()

    init(type: InfoType) {
        infoType = type
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func setupModel(runtime: Int, star: Double, releasedDate: Int? = nil) {
        starLabel.text = "\(star)"
        runtimeLabel.text = "\(runtime) min"
        if let releasedDate, infoType == .detail {
            releasedYearLabel.text = "\(releasedDate)"
        }
    }
}

extension InfoStackView {
    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    private func setAttributes() {
        switch infoType {
        case .detail:
            spacing = 16
            runtimeLabel.font = .systemFont(ofSize: 13.6)
            starLabel.font = .systemFont(ofSize: 13.6)
        case .item:
            spacing = 12
            runtimeLabel.font = .systemFont(ofSize: 11.9)
            starLabel.font = .systemFont(ofSize: 11.9)
        }
    }

    private func setHierarchy() {
        [starImageView, starLabel].forEach {
            starStackView.addArrangedSubview($0)
        }

        [runtimeImageView, runtimeLabel].forEach {
            runtimeStackView.addArrangedSubview($0)
        }

        [starStackView, runtimeStackView].forEach {
            addArrangedSubview($0)
        }

        if infoType == .detail {
            addArrangedSubview(releasedYearLabel)
        }
    }

    private func setConstraints() {
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(infoType == .detail ? 16 : 14)
        }

        runtimeImageView.snp.makeConstraints { make in
            make.size.equalTo(infoType == .detail ? 16 : 14)
        }
    }
}
