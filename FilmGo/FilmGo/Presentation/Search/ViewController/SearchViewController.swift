//
//  SearchViewController.swift
//  FilmGo
//
//  Created by 유현진 on 4/30/25.
//

import UIKit
import RxSwift
import RxCocoa

enum SearchSection: Int, Hashable {
    case search = 0
}

final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    private let searchView = SearchView()
    private let disposeBag = DisposeBag()

    private var dataSource: UICollectionViewDiffableDataSource<
        SearchSection,
        Movie
    >!

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applySnapshot(items: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, Movie>()
        snapshot.appendSections([.search])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

private extension SearchViewController {
    func configure() {
        setAttributes()
        setDataSource()
        setBindings()
    }

    func setAttributes() {
        view.backgroundColor = .baseBlack
        navigationItem.searchController = searchView.searchController

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSection, Movie>(
            collectionView: searchView.searchCollectionView,
            cellProvider: { collectionView, indexPath, _ in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieVerticalCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? MovieVerticalCollectionViewCell else { return UICollectionViewCell() }
                cell.update(
                    posterImage: item.posterImage,
                    title: item.title,
                    genre: item.genres.joined(separator: ", "),
                    star: item.star,
                    runtime: item.runningTime
                )
                return cell
            }
        )

        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath
            -> UICollectionReusableView? in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeader.identifier,
                for: indexPath
            ) as? SectionHeader else { return nil }

            switch indexPath.section {
            case 0:
                headerView.update(with: .searchResult)
            default:
                break
            }
            return headerView
        }
    }

    func setBindings() {
        viewModel.state
            .map(\.movie)
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] in
                guard let self else { return }
                applySnapshot(items: $0)
            }
            .disposed(by: disposeBag)

        searchView.searchCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

//                navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
