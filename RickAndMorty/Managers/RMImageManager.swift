//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Sultan on 16/12/23.
//

import Foundation

final class RMImageManager {
    static var shared: RMImageManager = .init()

    private init() {}

    private var imageDataCache = NSCache<NSString, NSData>()

    public func downloadImage(url: URL) async throws -> Data {
        do {
            let key = url.absoluteString as NSString
            if let data = imageDataCache.object(forKey: key) {
                print("Fetching image from cache: \(url)")
                return data as Data
            }

            print("Fetching image from internet: \(url)")
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)

            let value = data as NSData
            imageDataCache.setObject(value, forKey: key)
            return data
        } catch {
            throw error
        }
    }
}
