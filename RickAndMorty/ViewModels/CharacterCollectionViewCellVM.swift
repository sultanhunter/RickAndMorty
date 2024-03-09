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

    public let characterId: Int
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?

    init(
        characterId: Int,
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterId = characterId
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }

    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
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
