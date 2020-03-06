enum MoviesListViewState {
    case ready([MoviesListViewModel])
    case loading
    case error
}

struct MoviesListViewModel {
    var posterURL: String
    var title: String
    var rating: Float
}
