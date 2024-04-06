//
//  CharacterPhotoCollectionViewCellVM.swift
//  RickAndMorty
//
//  Created by Sultan on 06/04/24.
//

import Foundation

final class CharacterPhotoCollectionViewCellVM {
    private let imageUrl: URL?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }

    public func fetchImage() async -> Data? {
        do {
            guard let imageUrl = imageUrl else {
                return nil
            }
            return try await RMImageManager.shared.downloadImage(url: imageUrl)
        } catch {
            return nil
        }
    }
}
