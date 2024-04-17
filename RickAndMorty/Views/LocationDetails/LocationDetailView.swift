//
//  LocationDetailsView.swift
//  RickAndMorty
//
//  Created by Sultan on 16/04/24.
//

import UIKit

protocol LocationDetailViewDelegate: AnyObject {
    func didSelectCharacter(_ character: RMCharacter)
}

class LocationDetailView: UIView {
    public weak var delegate: LocationDetailViewDelegate?

    private let viewModel: LocationDetailViewVM

    private var collectionView: UICollectionView?

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()

    init(location: RMLocation) {
        viewModel = .init(location: location)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        viewModel.delegate = self

        collectionView = createCollectionView()
        addSubviews(collectionView!, spinner)
        addConstraints()

        Task {
            await viewModel.fetchLocationData()
        }
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.register(LocationInfoCollectionViewCell.self, forCellWithReuseIdentifier: LocationInfoCollectionViewCell.cellIdentifier)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }

    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)

        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension LocationDetailView {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard viewModel.cellViewModels.count > 0 else { return createInfoLayout() }
        let sections = viewModel.cellViewModels
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }

    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240)), subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension LocationDetailView: LocationDetailViewVMDelegate {
    func didFetchLocationDetails() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
            self?.spinner.stopAnimating()
            self?.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.9) {
                self?.collectionView?.alpha = 1
            }
        }
    }

    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.didSelectCharacter(character)
    }
}
