//
//  RMAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Sultan on 08/04/24.
//

import Foundation

struct RMAllEpisodesResponse: Codable {
    let info: AllEpisodesResponseInfo
    let results: [RMEpisode]
}

struct AllEpisodesResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
