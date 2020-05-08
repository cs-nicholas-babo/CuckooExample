import Foundation

protocol RequestManagerProtocol {
    func request(_ url: String,
                 completion: @escaping (Result<[Movie], Error>) -> Void)
}
