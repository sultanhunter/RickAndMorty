//
//  RMAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Sultan on 08/04/24.
//

import Foundation

struct RMAllLoactionsResponse: Codable {
    let info: AllLoactionsResponseInfo
    let results: [RMLocation]
}

struct AllLoactionsResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
