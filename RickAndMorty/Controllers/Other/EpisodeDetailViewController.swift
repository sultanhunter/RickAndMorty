//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 07/04/24.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {
    private let detailView: EpisodeDetailView
    private let episode: String
    init(url: URL, episode: String) {
        self.detailView = EpisodeDetailView(endpointUrl: url)
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
        detailView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = episode
        view.addSubview(detailView)
        view.backgroundColor = .systemBackground
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)

        ])
    }

    @objc
    private func didTapShare() {}
}

extension EpisodeDetailViewController: EpisodeDetailViewDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let vc = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(vc, animated: true)
    }
}
