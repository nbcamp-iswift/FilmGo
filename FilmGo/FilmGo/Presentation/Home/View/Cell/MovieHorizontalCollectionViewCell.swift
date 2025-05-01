//
//  MovieHorizontalCollectionViewCell.swift
//  FilmGo
//
//  Created by 유현진 on 4/29/25.
//

import UIKit
import SnapKit
import RxSwift

final class MovieHorizontalCollectionViewCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let titleGenreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.9, weight: .medium)
        label.textColor = .baseWhite
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.2)
        label.textColor = .neutrals200
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageView.image = nil
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func update(posterImagePath: String, title: String, genre: String) {
        titleLabel.text = title
        genreLabel.text = genre

        ImageCacheService.shared
            .loadProgressiveImage(
                path: posterImagePath,
                imageDownloader: DefaultNetworkService().downloadImage
            )
            .compactMap { UIImage(data: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                UIView.transition(
                    with: self?.imageView ?? UIImageView(),
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        self?.imageView.image = image
                    }
                )
            })
            .disposed(by: disposeBag)
    }
}

private extension MovieHorizontalCollectionViewCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .neutrals600
    }

    func setHierarchy() {
        [
            titleLabel,
            genreLabel,
        ].forEach {
            titleGenreStackView.addArrangedSubview($0)
        }

        [
            imageView,
            titleGenreStackView,
        ].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.78)
        }

        titleGenreStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
