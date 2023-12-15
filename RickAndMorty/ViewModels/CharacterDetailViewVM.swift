//
//  CharacterDetailVM.swift
//  RickAndMorty
//
//  Created by Sultan on 15/12/23.
//

import Foundation

final class CharacterDetailViewVM {
    private let character: RMCharacter

    init(character: RMCharacter) {
        self.character = character
    }

    public var title: String {
        character.name.uppercased()
    }
}
