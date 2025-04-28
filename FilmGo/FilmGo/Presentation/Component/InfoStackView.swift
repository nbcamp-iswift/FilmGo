//
//  InfoStackView.swift
//  FilmGo
//
//  Created by 유현진 on 4/28/25.
//

import UIKit
import SnapKit

final class InfoStackView: UIStackView {
    private let infoType: InfoType

    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .star
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
        imageView.image = .runtime
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

    func update(runtime: Int, star: String, releasedDate: Int? = nil) {
        starLabel.text = "\(star)"
        runtimeLabel.text = "\(runtime) min"
        if let releasedDate, infoType == .detail {
            releasedYearLabel.text = "\(releasedDate)"
        }
    }
}

private extension InfoStackView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        spacing = infoType.spacing
        runtimeLabel.font = infoType.font
        starLabel.font = infoType.font
    }

    func setHierarchy() {
        [
            starImageView,
            starLabel
        ].forEach {
            starStackView.addArrangedSubview($0)
        }

        [
            runtimeImageView,
            runtimeLabel
        ].forEach {
            runtimeStackView.addArrangedSubview($0)
        }

        [
            starStackView,
            runtimeStackView
        ].forEach {
            addArrangedSubview($0)
        }

        if infoType == .detail {
            addArrangedSubview(releasedYearLabel)
        }
    }

    func setConstraints() {
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(infoType.imageSize)
        }

        runtimeImageView.snp.makeConstraints { make in
            make.size.equalTo(infoType.imageSize)
        }
    }
}

extension InfoStackView {
    enum InfoType {
        case item
        case detail

        var font: UIFont {
            switch self {
            case .item:
                return .systemFont(ofSize: 11.9)
            case .detail:
                return .systemFont(ofSize: 13.6)
            }
        }

        var spacing: CGFloat {
            switch self {
            case .item:
                return 12
            case .detail:
                return 16
            }
        }

        var imageSize: CGFloat {
            switch self {
            case .item:
                return 14
            case .detail:
                return 16
            }
        }
    }
}
