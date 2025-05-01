//
//  SearchView.swift
//  FilmGo
//
//  Created by 유현진 on 4/30/25.
//

import UIKit
import SnapKit

final class SearchView: UIView {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.searchBar.placeholder = "영화 제목, 배우, 감독을 검색하세요."
        searchController.searchBar.backgroundColor = .baseBlack
        searchController.searchBar.searchTextField.font = .systemFont(ofSize: 16)
        searchController.searchBar.searchTextField.textColor = .neutrals100
        searchController.searchBar.searchTextField.backgroundColor = .neutrals600
        return searchController
    }()

    lazy var searchCollectionView: UICollectionView = {
        let layout =
            UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                guard let section = SearchSection(rawValue: sectionIndex) else { return nil }
                return self.createSection(for: section)
            }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
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

private extension SearchView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .baseBlack
    }

    func setHierarchy() {
        addSubview(searchCollectionView)
    }

    func setConstraints() {
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

private extension SearchView {
    func createSection(for sectionIndex: SearchSection) -> NSCollectionLayoutSection {
        switch sectionIndex {
        case .search:
            return makeVerticalLayout()
        }
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
            heightDimension: .fractionalHeight(0.23)
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
