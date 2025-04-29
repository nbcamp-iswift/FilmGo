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

    private let contentView = UIView()

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
            forCellWithReuseIdentifier: OrderCell.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        return collectionView
    }()

    private let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = .neutrals600
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        return stackView
    }()

    private let orderHistoryView = MenuItemView(type: .orderHistory)

    private let logoutView = MenuItemView(type: .logout)

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
            contentView,
        ].forEach { addSubview($0) }

        [
            userView,
            orderCollectionView,
            menuStackView,
        ].forEach { contentView.addSubview($0) }

        [
            orderHistoryView,
            logoutView,
        ].forEach { menuStackView.addArrangedSubview($0) }
    }

    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }

        userView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }

        orderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(366)
        }

        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(orderCollectionView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    func setDataSource() {
        dataSource = .init(collectionView: orderCollectionView) { collection, indexPath, item
            -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(
                withReuseIdentifier: OrderCell.reuseIdentifier,
                for: indexPath
            ) as? OrderCell else { return nil }

            cell.update(with: item)

            return cell
        }

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath
            -> UICollectionReusableView? in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as? SectionHeader else { return nil }
            headerView.update(with: .latestOrder)
            return headerView
        }

        var initialSnapshot = NSDiffableDataSourceSnapshot<MyPageSection, Order>()
        initialSnapshot.appendSections([.orders])
        dataSource?.apply(initialSnapshot)
    }

    func createLayout() -> UICollectionViewLayout {
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
            heightDimension: .absolute(144)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.88),
            heightDimension: .absolute(304)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MyPageView {
    enum MyPageSection: Hashable {
        case orders
    }
}
