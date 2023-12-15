//
//  AllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Sultan on 14/12/23.
//

import Foundation

struct RMAllCharactersResponse: Codable {
    let info: AllCharactersResponseInfo
    let results: [RMCharacter]
}

struct AllCharactersResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
