//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 15/12/23.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    private let detailView: CharacterDetailView

    init(viewModel: CharacterDetailViewVM) {
        self.detailView = CharacterDetailView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        view.addSubviews(detailView)
        addShareButton()
        addConstraints()
    }

    private func fetchCharacterInfo() {}

    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self,
            action: #selector(onShareTap))
    }

    @objc
    private func onShareTap() {}

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)

        ])
    }
}
