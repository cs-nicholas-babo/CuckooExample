import Quick
import Nimble
import Nimble_Snapshots
import Cuckoo

@testable import CuckooExample

final class MoviesListViewControllerTests: QuickSpec {

    override func spec() {
        var sut: MoviesListViewController!
        var presenterMock: MockMoviesListPresenterProtocol!
        var contentViewMock: MockMoviesListView!

        beforeEach {
            presenterMock = MockMoviesListPresenterProtocol()
            contentViewMock = MockMoviesListView()
            sut = MoviesListViewController(presenter: presenterMock,
                                           contentView: contentViewMock)
            stubPresenter()
            stubContentView()
        }

        describe("#viewDidLoad") {
            var argumentCaptor: ArgumentCaptor<Int>!

            beforeEach {
                argumentCaptor = ArgumentCaptor<Int>()
                sut.viewDidLoad()
            }

            it("calls getInitialMovies on presenter") {
                verify(presenterMock).getInitialMovies()
            }

            context("bindLayoutEvents") {
                it("binds view's didTapMovieAction to presenter didSelectMovie") {
                    contentViewMock.didTapMovieAction?(10)

                    verify(presenterMock).didSelectMovie(at: argumentCaptor.capture())

                    expect(argumentCaptor.value).to(equal(10))
                }
            }
        }

        describe("#set") {
            context("ready state") {
                it("calls show on contentView") {
                    let viewModel = createViewModels()
                    sut.set(state: .ready(viewModel))

                    verify(contentViewMock).show(equal(to: viewModel))
                }
            }
        }

        func stubPresenter() {
            stub(presenterMock) { mock in
                when(mock).getInitialMovies().thenDoNothing()
                when(mock).didSelectMovie(at: any()).thenDoNothing()
            }
        }

        func stubContentView() {
            stub(contentViewMock) { mock in
                when(mock).show(any()).thenDoNothing()
                when(mock).showError().thenDoNothing()
                when(mock).setLoading(any()).thenDoNothing()
                when(mock).didTapMovieAction.get.thenCallRealImplementation()
                when(mock).didTapMovieAction.set(any()).thenCallRealImplementation()
            }
        }

        func createViewModels() -> MoviesListViewModel {
            return MoviesListViewModel(posterURL: "", title: "", rating: 5)
        }
    }
}
