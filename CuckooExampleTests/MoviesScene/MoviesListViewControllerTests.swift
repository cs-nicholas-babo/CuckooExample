import Quick
import Nimble
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
            it("calls getInitialMovies on presenter") {
                sut.viewDidLoad()

                verify(presenterMock).getInitialMovies()
            }

            context("bindLayoutEvents") {
                it("binds view's didTapMovieAction to presenter didSelectMovie") {
                    let argumentCaptor = ArgumentCaptor<Int>()

                    contentViewMock.didTapMovieAction?(10)

                    verify(presenterMock).didSelectMovie(at: argumentCaptor.capture())

                    expect(argumentCaptor.value).to(equal(10))
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
                when(mock).didTapMovieAction.get.thenCallRealImplementation()
                when(mock).didTapMovieAction.set(any()).thenCallRealImplementation()
            }
        }
    }
}
