//
//  HomeViewController.swift
//  FilmGo
//
//  Created by 유현진 on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

enum MovieSection: Int, Hashable {
    case nowPlaying = 0
    case popular = 1
}

enum MovieSectionItem: Hashable {
    case nowPlaying(Movie)
    case popular(Movie)
}

final class HomeViewController: UIViewController {
    private weak var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()

    private var dataSource: UICollectionViewDiffableDataSource<
        MovieSection,
        MovieSectionItem
    >!

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.applyFGNavigationBarStyle(.large(title: "FilmGo"))
        tabBarController?.tabBar.isHidden = false
    }

    init(viewModel: HomeViewModel, coordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applySnapshot(items: [MovieSectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSection, MovieSectionItem>()
        snapshot.appendSections([.nowPlaying, .popular])

        snapshot.appendItems(
            items.filter {
                if case .nowPlaying = $0 { return true }
                return false
            },
            toSection: .nowPlaying
        )

        snapshot.appendItems(
            items.filter {
                if case .popular = $0 { return true }
                return false
            },
            toSection: .popular
        )
        dataSource.apply(snapshot)
    }
}

private extension HomeViewController {
    func configure() {
        setAttributes()
        setDataSource()
        setBindings()
    }

    func setAttributes() {
        view.backgroundColor = .baseBlack
    }

    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieSection, MovieSectionItem>(
            collectionView: homeView.movieCollectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .nowPlaying(let movie):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MovieHorizontalCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? MovieHorizontalCollectionViewCell else { return UICollectionViewCell() }
                    cell.update(
                        posterImagePath: movie.posterImagePath,
                        title: movie.title,
                        genre: movie.genres.joined(separator: ", ")
                    )
                    return cell
                case .popular(let movie):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MovieVerticalCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? MovieVerticalCollectionViewCell else { return UICollectionViewCell() }
                    cell.update(
                        posterImagePath: movie.posterImagePath,
                        title: movie.title,
                        genre: movie.genres.joined(separator: ", "),
                        star: movie.star,
                        runtime: movie.runningTime
                    )
                    return cell
                }
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
                headerView.update(with: .nowPlaying)
            case 1:
                headerView.update(with: .popularMovie)
            default:
                break
            }
            return headerView
        }
    }

    func setBindings() {
        viewModel.action.accept(.fetchNowPlaying)
        viewModel.action.accept(.fetchPopular)

        viewModel.state
            .map(\.movie)
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] in
                guard let self else { return }
                applySnapshot(items: $0)
            }
            .disposed(by: disposeBag)

        homeView.movieCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

                switch item {
                case .nowPlaying(let movie):
                    coordinator?.showDetailView(movie: movie)
                case .popular(let movie):
                    coordinator?.showDetailView(movie: movie)
                }
            })
            .disposed(by: disposeBag)
    }
}
