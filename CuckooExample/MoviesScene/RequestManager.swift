import Foundation

protocol RequestManagerProtocol {
    func request(_ url: String,
                 completion: @escaping (Result<[Movie], Error>) -> Void)
}

final class RequestManager: RequestManagerProtocol {

    func request(_ url: String,
                 completion: @escaping (Result<[Movie], Error>) -> Void) {
        let parasite = Movie()
        completion(.success([parasite]))
    }
}

struct Movie {
    var title: String = "Parasite"
    var rating: Float = 10.0
    var posterURL: String = ""
    var director: String = "Bong Joon-ho"
    var releaseDate: Date = Date()
}
