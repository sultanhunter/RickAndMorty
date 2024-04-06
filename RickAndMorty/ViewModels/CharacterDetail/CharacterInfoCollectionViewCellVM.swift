//
//  CharacterInfoCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Sultan on 06/04/24.
//

import Foundation

final class CharacterInfoCollectionViewCellVM {
    public let value: String
    public let title: String
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
