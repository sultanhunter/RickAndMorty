//
//  CharacterEpisodeCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Sultan on 06/04/24.
//

import UIKit

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class CharacterEpisodeCollectionViewCellVM: Equatable {
    static func == (lhs: CharacterEpisodeCollectionViewCellVM, rhs: CharacterEpisodeCollectionViewCellVM) -> Bool {
        lhs.episodeDataUrl == rhs.episodeDataUrl
    }

    private let episodeDataUrl: URL?
    private var isFetching = false

    private var dataBlock: ((RMEpisodeDataRender) -> Void)?

    private var episodeData: RMEpisode? {
        didSet {
            guard let model = episodeData else { return }
            dataBlock?(model)
        }
    }

    public let borderColor: UIColor

    init(episodeDatatUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDatatUrl
        self.borderColor = borderColor
    }

    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        dataBlock = block
    }

    public func fetchEpisodeData() async {
        guard !isFetching, episodeData == nil else {
            if let data = episodeData {
                dataBlock?(data)
            }
            return
        }
        guard let url = episodeDataUrl, let apiRequest = ApiRequest(url: url) else { return }
        do {
            isFetching = true
            let data = try await ApiService.shared.execute(apiRequest, expecting: RMEpisode.self)
            episodeData = data
            isFetching = false
        } catch {
            isFetching = false
        }
    }
}
