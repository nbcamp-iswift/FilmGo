import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = DefaultNetworkService()
        let repository = DefaultMovieRepository(networkService: service)
        let moviesSingle = repository.fetchPopularMovies(page: 1)

        moviesSingle.subscribe { [weak self] result in
            switch result {
            case .success(let movies):
                let useCase = FetchMovieUseCase(repository: repository)
                guard let movieID = movies.movies.first?.movieId else { return }
                let vm = DetailViewModel(
                    movieID: movieID,
                    fetchMovieUseCase: useCase
                )
                let vc = DetailViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                break
            }
        }
        .disposed(by: disposeBag)
    }
}
