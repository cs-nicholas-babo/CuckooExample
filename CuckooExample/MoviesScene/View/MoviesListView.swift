import UIKit

class MoviesListView: UIView {

    private lazy var titleLabel: UILabel = UILabel()
    private lazy var posterImageView: UIImageView = UIImageView()
    private lazy var ratingsView: UIView = UIView()

    var didTapMovieAction: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViewHierarchy() {
        addSubview(titleLabel)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func show(_ viewModel: MoviesListViewModel) {
        titleLabel.text = viewModel.title
        posterImageView.image = downloadImage(from: viewModel.posterURL)
        ratingsView.setRating(viewModel.rating)
    }

    func setLoading(_ loading: Bool) {
        let loadingText = loading ? "Loading ..." : "Loading ended"
        titleLabel.text = loadingText
    }

    func showError() {
        titleLabel.text = "Error!"
    }

    private func downloadImage(from url: String) -> UIImage? {
        nil
    }
}

extension UIView {
    func setRating(_ rating: Float) {

    }
}
