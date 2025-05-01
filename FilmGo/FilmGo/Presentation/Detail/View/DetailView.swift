//
//  DetailView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/28/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailView: UIView {
    let didTapbookButton = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView = UIView()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 25.5)
        label.numberOfLines = 0
        return label
    }()

    private let infoStackView = InfoStackView(type: .detail)

    private let genresStackView = TagsScrollView()

    private let overviewHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let overviewContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview Content"
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 13.6)
        label.numberOfLines = 0
        return label
    }()

    private let directorHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let directorContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Director Name"
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 13.6)
        return label
    }()

    private let actorsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "출연진"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let actorsStackView = TagsScrollView()

    private let bookButton = FGButton(type: .book)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with movie: Movie) {
        posterImageView.image = UIImage(data: movie.posterImage)
        titleLabel.text = movie.title
        infoStackView.update(
            runtime: movie.runningTime,
            star: movie.star,
            releasedDate: movie.releasedYear
        )
        genresStackView.updateTags(movie.genres)
        overviewContentLabel.text = movie.overview
        directorContentLabel.text = movie.director
        actorsStackView.updateTags(movie.actors)
    }
}

private extension DetailView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .baseBlack
    }

    func setHierarchy() {
        [
            posterImageView,
            titleLabel,
            infoStackView,
            genresStackView,
            overviewHeaderLabel,
            overviewContentLabel,
            directorHeaderLabel,
            directorContentLabel,
            actorsHeaderLabel,
            actorsStackView,
            bookButton,
        ].forEach { contentView.addSubview($0) }
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }

    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(262)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }

        genresStackView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        overviewHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(genresStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        overviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewHeaderLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }

        directorHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewContentLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        directorContentLabel.snp.makeConstraints { make in
            make.top.equalTo(directorHeaderLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }

        actorsHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(directorContentLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        actorsStackView.snp.makeConstraints { make in
            make.top.equalTo(actorsHeaderLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        bookButton.snp.makeConstraints { make in
            make.top.equalTo(actorsStackView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }

    func setBindings() {
        bookButton.rx.tap
            .bind(to: didTapbookButton)
            .disposed(by: disposeBag)
    }
}
