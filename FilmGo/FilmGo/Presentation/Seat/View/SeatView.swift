//
//  SeatView.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SeatView: UIView {
    let didTapCell = PublishRelay<IndexPath>()

    private var dataSource: UICollectionViewDiffableDataSource<Section, SeatItem>?
    private let disposeBag = DisposeBag()

    private let screenView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary500
        view.layer.cornerRadius = 4
        return view
    }()

    private let screenLabel: UILabel = {
        let label = UILabel()
        label.text = "SCREEN"
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 11.9)
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
            SeatCell.self,
            forCellWithReuseIdentifier: SeatCell.identifier
        )
        return collectionView
    }()

    private let selectedSeatsLabel: UILabel = {
        let label = UILabel()
        label.text = "좌석을 선택해 주세요"
        label.textColor = .neutrals200
        label.font = .systemFont(ofSize: 13.6)
        return label
    }()

    private let payButton = FGButton(type: .pay)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateSelectedSeats(_ selectedSeats: [Int]) {
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, SeatItem>()
        let newItems = (0 ..< 64).map {
            let state: SeatItem.State = selectedSeats.contains($0) ? .alreadySelected : .selectable
            return SeatItem(number: $0, state: state)
        }
        newSnapshot.appendSections([.main])
        newSnapshot.appendItems(newItems)
        dataSource?.apply(newSnapshot)
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 8.0),
            heightDimension: .fractionalWidth(1.0 / 8.0),
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 4.0,
            leading: 4.0,
            bottom: 4.0,
            trailing: 4.0,
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 8.0),
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item],
        )

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

private extension SeatView {
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
            screenView,
            screenLabel,
            collectionView,
            selectedSeatsLabel,
            payButton,
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        screenView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(8)
        }

        screenLabel.snp.makeConstraints { make in
            make.top.equalTo(screenView.snp.bottom).offset(9.5)
            make.centerX.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(screenLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(380)
        }

        selectedSeatsLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        payButton.snp.makeConstraints { make in
            make.top.equalTo(selectedSeatsLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }

    func setDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SeatCell.identifier,
                for: indexPath,
            ) as? SeatCell else { fatalError() }
            cell.updateLayout(for: item.state)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, SeatItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(
            (0 ..< 64).map { SeatItem(number: $0, state: .selectable) }
        )
        dataSource?.apply(snapshot)
    }
}

extension SeatView {
    enum Section {
        case main
    }
}
