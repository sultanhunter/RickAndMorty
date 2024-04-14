//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 13/12/23.
//

import UIKit

final class EpisodeViewController: UIViewController, EpisodeListViewDelegate {
    private let episodeListView = EpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addSearchButton()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {}

    private func setUpView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)

        ])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        episodeListView.onViewTransition()
    }

    func episodeSelected(_ episodeListView: EpisodeListView, selectedEpisode episode: RMEpisode) {
        guard let url = URL(string: episode.url) else { return }
        let vc = EpisodeDetailViewController(url: url, episode: episode.episode)
        navigationController?.pushViewController(vc, animated: true)
    }
}
