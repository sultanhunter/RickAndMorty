//
//  EpisodeDetailViewVM.swift
//  RickAndMorty
//
//  Created by Sultan on 07/04/24.
//

import UIKit

protocol EpisodeDetailViewVMDelegate: AnyObject {
    func didFetchEpisodeDetails()
    func didSelectCharacter(_ character: RMCharacter)
}

final class EpisodeDetailViewVM: NSObject {
    private let endpointUrl: URL?

    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellVM])
        case characters(viewModels: [CharacterCollectionViewCellVM])
    }

    public private(set) var cellViewModels: [SectionType] = []

    public weak var delegate: EpisodeDetailViewVMDelegate?

    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = {
            if let date = CharacterInfoCollectionViewCellVM.dateFormatter.date(from: episode.created) {
                return CharacterInfoCollectionViewCellVM.shortDateFormatter.string(from: date)
            } else {
                return ""
            }
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString())
            ]),
            .characters(viewModels: characters.compactMap {
                CharacterCollectionViewCellVM(character: $0)
            })
        ]
    }

    public func fetchEpisodeData() async {
        guard let url = endpointUrl, let request = ApiRequest(url: url) else { return }
        do {
            let episode = try await ApiService.shared.execute(request, expecting: RMEpisode.self)
            await fetchRelatedCharacters(episode: episode)
        } catch {}
    }

    private func fetchRelatedCharacters(episode: RMEpisode) async {
        let characterUrls: [URL] = episode.characters.compactMap {
            URL(string: $0)
        }

        let requests: [ApiRequest] = characterUrls.compactMap {
            ApiRequest(url: $0)
        }

        let characterCollection = CharacterCollection()

        let group = DispatchGroup()
        for request in requests {
            group.enter()
            Task {
                do {
                    let character = try await ApiService.shared.execute(request, expecting: RMCharacter.self)
                    await characterCollection.addCharacter(character)
                } catch {}
                group.leave()
            }
        }

        group.notify(queue: .main, execute: {
            Task { [weak self] in
                self?.dataTuple = (episode: episode, characters: await characterCollection.getCharacters())
            }
        })
    }
}

actor CharacterCollection {
    private var characters: [RMCharacter] = []

    func addCharacter(_ character: RMCharacter) {
        characters.append(character)
    }

    func getCharacters() -> [RMCharacter] {
        return characters
    }
}

extension EpisodeDetailViewVM: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = cellViewModels[section]

        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = cellViewModels[indexPath.section]

        switch sectionType {
        case .information(let viewModels):
            let viewModel = viewModels[indexPath.row]

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? EpisodeInfoCollectionViewCell
            else { fatalError() }

            cell.configure(with: viewModel)
            return cell
        case .characters(let viewModels):
            let viewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell
            else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = cellViewModels[indexPath.section]
        switch sectionType {
        case .information:
            break
        case .characters(let viewModels):
            delegate?.didSelectCharacter(viewModels[indexPath.row].character)
        }
    }
}
