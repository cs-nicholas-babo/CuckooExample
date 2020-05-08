import Quick
import Nimble
import Cuckoo

@testable import CuckooExample

final class MoviesListPresenterTests: QuickSpec {

    override func spec() {
        var sut: MoviesListPresenter!
        var requestManagerMock: MockRequestManagerProtocol!
        var viewControllerMock: MockMoviesListViewControllerProtocol!

        beforeEach {
            requestManagerMock = MockRequestManagerProtocol()
            viewControllerMock = MockMoviesListViewControllerProtocol()

            sut = MoviesListPresenter(requestManager: requestManagerMock)

            sut.controller = viewControllerMock

            stubViewController()
            stubRequestManager(with: .success([]))
        }

        describe("#getInitialMovies") {
            it("calls request on requestManager with expected endpoint") {
                sut.getInitialMovies()

                verify(requestManagerMock).request(equal(to: "/getMovies"),
                                                   completion: any())
            }

            var argumentCaptor: ArgumentCaptor<MoviesListViewState>!

            beforeEach {
                argumentCaptor = ArgumentCaptor<MoviesListViewState>()
            }

            context("on request success") {
                it("calls show on viewController 2 times (loading, success)") {
                    stubRequestManager(with: .success([]))
                    sut.getInitialMovies()

                    verify(viewControllerMock, times(2)).set(state: argumentCaptor.capture())

                    expect(argumentCaptor.allValues.first).to(equal(.loading))
                    expect(argumentCaptor.allValues[1]).to(equal(.ready([])))
                }
            }

            context("on request failure") {
                it("calls show on viewController 2 times (loading, error)") {
                    stubRequestManager(with: .failure(NSError()))
                    sut.getInitialMovies()

                    verify(viewControllerMock, times(2)).set(state: argumentCaptor.capture())

                    expect(argumentCaptor.allValues.first).to(equal(.loading))
                    expect(argumentCaptor.allValues[1]).to(equal(.error))
                }
            }
        }

        func stubViewController() {
            stub(viewControllerMock) { mock in
                when(mock).set(state: any()).thenDoNothing()
            }
        }

        func stubRequestManager(with mockedCompletion: Result<[Movie], Error>) {
            stub(requestManagerMock) { mock in
                when(mock).request(any(), completion: any()).then { _, completion in
                    completion(mockedCompletion)
                }
            }
        }

    }
}
