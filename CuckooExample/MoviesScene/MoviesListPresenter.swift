import Foundation

protocol MoviesListPresenterProtocol {
    func getInitialMovies()
}

final class MoviesListPresenter: MoviesListPresenterProtocol {

    weak var controller: MoviesListViewControllerProtocol?
    private let requestManager: RequestManagerProtocol

    private var state: MoviesListViewState = .loading {
        didSet {
            controller?.set(state: state)
        }
    }

    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    func getInitialMovies() {
        state = .loading

        requestManager.request("/getMovies") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                let viewModel = self.adapt(movies)
                self.state = .ready(viewModel)
            case .failure:
                self.state = .error
            }
        }
    }

    private func adapt(_ movies: [Movie]) -> [MoviesListViewModel] {
        return movies.map {
            MoviesListViewModel(posterURL: $0.posterURL,
                                title: $0.title,
                                rating: $0.rating)
        }
    }
    

}
