//
//  MovieVerticalCollectionViewCell.swift
//  FilmGo
//
//  Created by 유현진 on 4/29/25.
//

import UIKit
import SnapKit
import RxSwift

final class MovieVerticalCollectionViewCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let titleGenreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.5
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.6, weight: .medium)
        label.textColor = .baseWhite
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.9)
        label.textColor = .neutrals200
        return label
    }()

    private let infoStackView: InfoStackView = {
        let infoStackView = InfoStackView(type: .item)
        infoStackView.distribution = .fillProportionally
        return infoStackView
    }()

    private let bookButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.baseWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11.9)
        button.clipsToBounds = true
        button.backgroundColor = .primary500
        button.layer.cornerRadius = 14
        return button
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

    func update(
        posterImagePath: String,
        title: String,
        genre: String,
        star: String,
        runtime: String
    ) {
        imageView.setProgressiveImage(by: posterImagePath)
        titleLabel.text = title
        genreLabel.text = genre
        infoStackView.update(runtime: runtime, star: star)

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

private extension MovieVerticalCollectionViewCell {
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
            infoStackView,
            bookButton,
        ].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height).dividedBy(1.5)
        }

        titleGenreStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleGenreStackView.snp.bottom).offset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }

        bookButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(18)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(28)
        }
    }
}
