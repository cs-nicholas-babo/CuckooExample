import Foundation

protocol MoviesListPresenterProtocol {
    func getInitialMovies()
    func didSelectMovie(at index: Int)
}

protocol MoviesListViewControllerProtocol: AnyObject {
    func set(state: MoviesListViewState)
}
