//
//  SectionHeader.swift
//  FilmGo
//
//  Created by 곽다은 on 4/29/25.
//

import UIKit
import SnapKit

final class SectionHeader: UICollectionReusableView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseWhite
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func update(with type: SectionType) {
        symbolImageView.isHidden = type.symbol == nil
        symbolImageView.image = type.symbol
        titleLabel.font = type.font
        titleLabel.text = type.rawValue
    }
}

private extension SectionHeader {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [
            stackView
        ].forEach { addSubview($0) }

        [
            symbolImageView,
            titleLabel,
        ].forEach { stackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(28)
        }

        symbolImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
}

extension SectionHeader {
    enum SectionType: String {
        case nowPlaying = "현재 상영작"
        case popularMovie = "인기 영화"
        case synopsis = "줄거리"
        case selectDate = "날짜 선택"
        case selectTime = "시간 선택"
        case searchResult = "검색 결과"
        case latestOrder = "최근 예매 내역"

        var symbol: UIImage? {
            switch self {
            case .selectDate:
                return .calendar
            case .selectTime:
                return .clock
            default:
                return nil
            }
        }

        var font: UIFont {
            switch self {
            case .nowPlaying, .popularMovie, .synopsis:
                return .systemFont(ofSize: 17, weight: .bold)
            default:
                return .systemFont(ofSize: 15.3, weight: .semibold)
            }
        }
    }
}
