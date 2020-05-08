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
            stubRequestManager(with: .success([Movie()]))
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
                beforeEach {
                    sut.getInitialMovies()
                }

                it("calls show on viewController 2 times (loading, success)") {
                    let expectedViewModel = MoviesListViewModel(posterURL: "",
                                                                title: "Parasite",
                                                                rating: 10.0)

                    verify(viewControllerMock, times(2)).set(state: argumentCaptor.capture())

                    expect(argumentCaptor.allValues.first).to(equal(.loading))
                    expect(argumentCaptor.allValues[1]).to(equal(.ready(expectedViewModel)))
                }
            }

            context("on request failure") {
                beforeEach {
                    stubRequestManager(with: .failure(NSError()))
                    sut.getInitialMovies()
                }

                it("calls show on viewController 2 times (loading, error)") {
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

        func stubRequestManager(with mockedResult: Result<[Movie], Error>) {
            stub(requestManagerMock) { mock in
                when(mock).request(any(), completion: any()).then { _, completion in
                    completion(mockedResult)
                }
            }
        }

    }
}
