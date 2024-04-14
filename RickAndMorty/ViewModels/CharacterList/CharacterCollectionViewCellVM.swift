//
//  CharacterCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Sultan on 14/12/23.
//

import Foundation

final class CharacterCollectionViewCellVM: Equatable {
    static func == (lhs: CharacterCollectionViewCellVM, rhs: CharacterCollectionViewCellVM) -> Bool {
        lhs.characterId == rhs.characterId
    }

    public let character: RMCharacter
    public var characterId: Int {
        character.id
    }

    public var characterName: String {
        character.name
    }

    public var characterStatus: RMCharacterStatus {
        character.status
    }

    public var characterSpecies: String {
        character.species
    }

    private var characterImageUrl: URL? {
        URL(string: character.image)
    }

    init(character: RMCharacter) {
        self.character = character
    }

    public var characterStatusText: String {
        return "\(characterStatus.text) - \(characterSpecies)"
    }

    public func fetchImage() async throws -> Data? {
        guard let url = characterImageUrl else { throw URLError(.badURL) }
        do {
            let imageData = try await RMImageManager.shared.downloadImage(url: url)
            return imageData
        } catch {
            return nil
        }
    }
}
