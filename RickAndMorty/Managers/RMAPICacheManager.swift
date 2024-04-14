//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Sultan on 07/04/24.
//

import Foundation

final class RMAPICacheManager {
    private var cacheDictionary: [ApiEndpoint: NSCache<NSString, NSData>] = [:]

    init() {
        setUpCache()
    }

    public func cachedResponse(for endpoint: ApiEndpoint, url: URL?) -> Data? {
        guard let targetCached = cacheDictionary[endpoint], let url = url else { return nil }
        let key = url.absoluteString as NSString
        return targetCached.object(forKey: key) as? Data
    }

    public func setCache(for endpoint: ApiEndpoint, url: URL?, data: Data) {
        guard let targetCached = cacheDictionary[endpoint], let url = url else { return }
        let key = url.absoluteString as NSString
        targetCached.setObject(data as NSData, forKey: key)
    }

    private func setUpCache() {
        ApiEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
