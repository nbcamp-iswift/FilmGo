//
//  HomeView.swift
//  FilmGo
//
//  Created by 유현진 on 4/28/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    lazy var movieCollectionView: UICollectionView = {
        let layout =
            UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                guard let section = MovieSection(rawValue: sectionIndex) else { return nil }
                return self.createSection(for: section)
            }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            MovieHorizontalCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieHorizontalCollectionViewCell.identifier
        )
        collectionView.register(
            MovieVerticalCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieVerticalCollectionViewCell.identifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        collectionView.backgroundColor = .baseBlack
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        addSubview(movieCollectionView)
    }

    func setConstraints() {
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

private extension HomeView {
    func createSection(for sectionIndex: MovieSection) -> NSCollectionLayoutSection {
        switch sectionIndex {
        case .nowPlaying:
            return makeHorizontalLayout()
        case .popular:
            return makeVerticalLayout()
        }
    }

    func makeHorizontalLayout() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(28)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(0.38)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 18.5, leading: 16, bottom: 32, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }

    func makeVerticalLayout() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(28)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 18.5, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
