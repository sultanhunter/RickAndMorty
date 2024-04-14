//
//  CharacterDetailVM.swift
//  RickAndMorty
//
//  Created by Sultan on 15/12/23.
//

import Foundation
import UIKit

protocol CharacterDetailViewVMDelegate: AnyObject {
    func didSelectEpisode(_ episodeURL: URL, episode: String)
}

final class CharacterDetailViewVM: NSObject {
    private var character: RMCharacter

    public weak var delegate: CharacterDetailViewVMDelegate?

    enum SectionType {
        case photo(viewModel: CharacterPhotoCollectionViewCellVM)
        case information(viewModel: [CharacterInfoCollectionViewCellVM])
        case episodes(viewModel: [CharacterEpisodeCollectionViewCellVM])
    }

    public var sections: [SectionType] = []

    init(character: RMCharacter) {
        self.character = character
        super.init()
        setUpSections()
    }

    private func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModel: [
                .init(type: .status, value: character.status.text),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)")

            ]),
            .episodes(viewModel: character.episode.compactMap {
                CharacterEpisodeCollectionViewCellVM(episodeDatatUrl: URL(string: $0))
            })
        ]
    }

    private var requestUrl: URL? {
        return URL(string: character.url)
    }

    public var title: String {
        character.name.uppercased()
    }
}

extension CharacterDetailViewVM: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]

        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterPhotoCollectionViewCell else {
                fatalError()
            }

            /// Adding viewModel to the cell
            cell.configure(with: viewModel)
            return cell

        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterInfoCollectionViewCell else {
                fatalError()
            }

            /// Adding viewModel to the cell
            cell.configure(with: viewModels[indexPath.row])
            return cell

        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterEpisodeCollectionViewCell else {
                fatalError()
            }

            /// Adding viewModel to the cell
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]

        switch sectionType {
        case .photo, .information: break

        case .episodes:
            let cell = collectionView.cellForItem(at: indexPath) as! CharacterEpisodeCollectionViewCell
            let episodes = character.episode
            let selection = episodes[indexPath.row]
            guard let url = URL(string: selection) else { return }
            delegate?.didSelectEpisode(url, episode: cell.episode ?? "")
        }
    }

    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
