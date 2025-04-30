//
//  OrderSection.swift
//  FilmGo
//
//  Created by youseokhwan on 4/29/25.
//

import UIKit

extension OrderView {
    enum OrderSection: Hashable {
        case date
        case time

        init(_ sectionIndex: Int) {
            switch sectionIndex {
            case 0:
                self = .date
            default:
                self = .time
            }
        }

        var sectionType: SectionHeader.SectionType {
            switch self {
            case .date:
                return .selectDate
            case .time:
                return .selectTime
            }
        }

        var itemSizeWidthDimension: CGFloat {
            switch self {
            case .date:
                return 1.0 / 5.0
            case .time:
                return 1.0 / 3.0
            }
        }

        var groupSizeHeightDimension: CGFloat {
            switch self {
            case .date:
                return 44.0
            case .time:
                return 48.0
            }
        }

        var layoutSection: NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(itemSizeWidthDimension),
                heightDimension: .fractionalHeight(1.0),
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
                heightDimension: .absolute(groupSizeHeightDimension),
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item],
            )

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(28),
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top,
            )
            header.contentInsets = NSDirectionalEdgeInsets(
                top: 8.0,
                leading: 8.0,
                bottom: 8.0,
                trailing: 8.0,
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 16.0,
                leading: 16.0,
                bottom: 16.0,
                trailing: 16.0,
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}
