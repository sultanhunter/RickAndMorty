//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Sultan on 15/12/23.
//

import UIKit

final class CharacterDetailView: UIView {
    private let viewModel: CharacterDetailViewVM

    private var collectionView: UICollectionView?

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    init(viewModel: CharacterDetailViewVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemPurple
        setupCollectionView()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported Error")
    }

    private func setupCollectionView() {
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }

    private func addConstraints() {
        guard let collectionView = collectionView else { return }
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

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSectionFor(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        /// Registering our 3 types of cell for our 3 sections in our compositional layout
        collectionView.register(CharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(CharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifier)
        collectionView.register(CharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }

    private func createSectionFor(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sections = viewModel.sections

        switch sections[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
    }
}
