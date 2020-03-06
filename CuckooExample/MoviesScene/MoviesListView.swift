import UIKit

class MoviesListView: UIView {

    private lazy var stateLabel: UILabel = UILabel()

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
        addSubview(stateLabel)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            stateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func show(_ viewModel: [MoviesListViewModel]) {
        let movieTitle = viewModel.first?.title ?? "nil title?"
        stateLabel.text = "READY: Movie - \(movieTitle)"
    }

    func setLoading(_ loading: Bool) {
        let loadingText = loading ? "Loading ..." : "Loading ended"
        stateLabel.text = loadingText
    }

    func showError() {
        stateLabel.text = "Error!"
    }
}
