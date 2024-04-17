//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Sultan on 13/12/23.
//

import UIKit

final class LocationViewController: UIViewController {
    private let primaryView = LocationListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstraints()
        primaryView.delegate = self
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {}
}

extension LocationViewController: LocationListViewDelegate {
    func didSelectLocation(_ location: RMLocation) {
        let vc = LocationDetailViewController(location: location)
        navigationController?.pushViewController(vc, animated: true)
    }
}
