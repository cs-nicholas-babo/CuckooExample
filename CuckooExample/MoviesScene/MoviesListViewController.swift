import UIKit

final class MoviesListViewController: UIViewController {

    private let contentView: MoviesListView
    private let presenter: MoviesListPresenterProtocol

    init(presenter: MoviesListPresenterProtocol,
         contentView: MoviesListView = MoviesListView()) {
        self.presenter = presenter
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLayoutEvents()
        presenter.getInitialMovies()
    }

    override func loadView() {
        self.view = contentView
    }

    private func bindLayoutEvents() {
        contentView.didTapMovieAction = { [weak self] index in

            self?.presenter.didSelectMovie(at: index)
        }
    }
}

extension MoviesListViewController: MoviesListViewControllerProtocol {
    func set(state: MoviesListViewState) {
        switch state {
        case .ready(let viewModel):
            contentView.show(viewModel)
        case .loading:
            contentView.setLoading(true)
        case .error:
            contentView.showError()
        }
    }
}
