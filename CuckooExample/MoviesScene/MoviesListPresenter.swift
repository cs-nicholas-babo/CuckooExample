import Foundation

final class MoviesListPresenter: MoviesListPresenterProtocol {

    weak var controller: MoviesListViewControllerProtocol?
    private let requestManager: RequestManagerProtocol

    private var movies: [Movie] = [] {
        didSet {
            self.state = .ready(adapt(movies))
        }
    }

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
                let viewModels = self.adapt(movies)
                self.state = .ready(viewModels)
            case .failure:
                self.state = .error
            }
        }
    }

    func didSelectMovie(at index: Int) {
        _ = movies[index]
    }

    private func adapt(_ movies: [Movie]) -> MoviesListViewModel {
        return movies.map {
            MoviesListViewModel(posterURL: $0.posterURL,
                                title: $0.title,
                                rating: $0.rating)
        }.first!
    }
}
