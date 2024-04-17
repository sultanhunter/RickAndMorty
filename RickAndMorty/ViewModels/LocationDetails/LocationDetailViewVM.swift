//
//  LocationDetailViewVM.swift
//  RickAndMorty
//
//  Created by Sultan on 16/04/24.
//

import UIKit

protocol LocationDetailViewVMDelegate: AnyObject {
    func didFetchLocationDetails()
    func didSelectCharacter(_ character: RMCharacter)
}

final class LocationDetailViewVM: NSObject {
    private let location: RMLocation

    public weak var delegate: LocationDetailViewVMDelegate?

    enum SectionType {
        case information(viewModels: [LocationInfoCollectionViewCellVM])
        case characters(viewModels: [CharacterCollectionViewCellVM])
    }

    public private(set) var cellViewModels: [SectionType] = []

    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.location
        let characters = dataTuple.characters

        let createdString = {
            if let date = CharacterInfoCollectionViewCellVM.dateFormatter.date(from: location.created) {
                return CharacterInfoCollectionViewCellVM.shortDateFormatter.string(from: date)
            } else {
                return ""
            }
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString())
            ]),
            .characters(viewModels: characters.compactMap {
                CharacterCollectionViewCellVM(character: $0)
            })
        ]
    }

    public func fetchLocationData() async {
        guard let url = URL(string: location.url), let request = ApiRequest(url: url) else { return }
        do {
            let location = try await ApiService.shared.execute(request, expecting: RMLocation.self)
            await fetchRelatedCharacters(location: location)
        } catch {}
    }

    private func fetchRelatedCharacters(location: RMLocation) async {
        let characterUrls: [URL] = location.residents.compactMap {
            URL(string: $0)
        }

        let requests: [ApiRequest] = characterUrls.compactMap {
            ApiRequest(url: $0)
        }

        let characterCollection = LocationCharactersActor()

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
                self?.dataTuple = (location: location, characters: await characterCollection.getCharacters())
            }
        })
    }

    init(location: RMLocation) {
        self.location = location
    }
}

actor LocationCharactersActor {
    private var characters: [RMCharacter] = []

    func addCharacter(_ character: RMCharacter) {
        characters.append(character)
    }

    func getCharacters() -> [RMCharacter] {
        return characters
    }
}

extension LocationDetailViewVM: UICollectionViewDelegate, UICollectionViewDataSource {
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

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationInfoCollectionViewCell.cellIdentifier, for: indexPath) as? LocationInfoCollectionViewCell
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
