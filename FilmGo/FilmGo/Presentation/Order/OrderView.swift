//
//  OrderView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit

final class OrderView: UIView {
    private var dataSource: UICollectionViewDiffableDataSource<OrderSection, String>?

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutrals800
        return view
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .baseWhite
        label.font = .boldSystemFont(ofSize: 15.3)
        label.numberOfLines = 0
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .baseBlack
        collectionView.isScrollEnabled = false
        collectionView.register(
            OrderItemCell.self,
            forCellWithReuseIdentifier: OrderItemCell.identifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        return collectionView
    }()

    private let selectSeatButton = FGButton(type: .selectSeat)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ ->
            NSCollectionLayoutSection in OrderSection(sectionIndex).layoutSection
        }
    }
}

private extension OrderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDataSource()
    }

    func setAttributes() {
        backgroundColor = .baseBlack
    }

    func setHierarchy() {
        [
            posterImageView,
            titleLabel,
        ].forEach { headerView.addSubview($0) }

        [
            headerView,
            collectionView,
            selectSeatButton,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.centerY.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(152)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(224)
        }

        selectSeatButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }

    func setDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderItemCell.identifier,
                for: indexPath,
            ) as? OrderItemCell else { fatalError() }
            cell.updateLabel(item)
            return cell
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self,
                  kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                      ofKind: kind,
                      withReuseIdentifier: SectionHeader.identifier,
                      for: indexPath,
                  ) as? SectionHeader,
                  let section = dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                return nil
            }

            header.update(with: section.sectionType)
            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<OrderSection, String>()
        snapshot.appendSections([.date, .time])
        snapshot.appendItems(["오늘", "내일", "월", "화", "수"], toSection: .date)
        snapshot.appendItems(
            ["10:00", "12:30", "15:00", "17:30", "20:00", "22:30"],
            toSection: .time,
        )
        dataSource?.apply(snapshot)
    }
}
