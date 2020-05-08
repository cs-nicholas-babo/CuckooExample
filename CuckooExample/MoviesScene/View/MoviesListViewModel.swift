enum MoviesListViewState: Equatable {
    case ready(MoviesListViewModel)
    case loading
    case error
}

struct MoviesListViewModel: Equatable {
    var posterURL: String
    var title: String
    var rating: Float
}
