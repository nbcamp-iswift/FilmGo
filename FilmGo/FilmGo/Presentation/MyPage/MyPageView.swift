//
//  MyPageView.swift
//  FilmGo
//
//  Created by 곽다은 on 4/28/25.
//

import UIKit
import SnapKit

final class MyPageView: UIView {
    private var dataSource: UICollectionViewDiffableDataSource<MyPageSection, Order>?

    private let userView = UserView()

    private lazy var orderCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .baseBlack
        collectionView.register(
            OrderCell.self,
            forCellWithReuseIdentifier: OrderCell.identifier
        )
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateUserView(with user: User) {
        userView.update(with: user)
    }

    func updateSnapshot(with items: [Order]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageSection, Order>()
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }
}

private extension MyPageView {
    func configure() {
        setAttributes()
        setHierachy()
        setConstraints()
        setDataSource()
    }

    func setAttributes() {
        backgroundColor = .baseBlack
    }

    func setHierachy() {
        [
            userView,
            orderCollectionView,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        userView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }

        orderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }

    func setDataSource() {
        dataSource = .init(collectionView: orderCollectionView) { collectionView, indexPath, item
            -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderCell.identifier,
                for: indexPath
            ) as? OrderCell else { return nil }

            cell.update(with: item)

            return cell
        }

        var initialSnapshot = NSDiffableDataSourceSnapshot<MyPageSection, Order>()
        initialSnapshot.appendSections([.orders])
        dataSource?.apply(initialSnapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.92),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

enum MyPageSection: Hashable {
    case orders
}
