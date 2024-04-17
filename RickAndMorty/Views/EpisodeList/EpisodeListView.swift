
import UIKit

protocol EpisodeListViewDelegate: AnyObject {
    func episodeSelected(_ episodeListView: EpisodeListView, selectedEpisode episode: RMEpisode)
}

final class EpisodeListView: UIView {
    public weak var delegate: EpisodeListViewDelegate?

    private let viewModel: EpisodeListViewVM

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(FooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingCollectionReusableView.indentifier)
        return collectionView
    }()

    init() {
        self.viewModel = EpisodeListViewVM()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        setUpCollectionView()
        Task {
            await viewModel.fetchInitialEpisodesList()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }

    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }

    public func onViewTransition() {
        collectionView.reloadData()
    }
}

extension EpisodeListView: EpisodeListViewVMDelegate {
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.episodeSelected(self, selectedEpisode: episode)
    }

    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.performBatchUpdates {
                self?.collectionView.insertItems(at: newIndexPaths)
            }
        }
    }

    func didLoadInitialCharacters() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
            UIView.animate(withDuration: 0.4, animations: {
                self?.collectionView.alpha = 1
            })
        }
    }
}
