//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 16/04/24.
//

import UIKit

class LocationDetailViewController: UIViewController {
    private let detailView: LocationDetailView

    init(location: RMLocation) {
        self.detailView = LocationDetailView(location: location)
        super.init(nibName: nil, bundle: nil)
        title = location.name
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
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

extension LocationDetailViewController: LocationDetailViewDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let vc = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(vc, animated: true)
    }
}
