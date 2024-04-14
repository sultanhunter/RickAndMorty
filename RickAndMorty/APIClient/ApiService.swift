
import Foundation

/// Primary API Service object to get Rick and Morty Data
final class ApiService {
    static let shared = ApiService()

    private let cacheManager = RMAPICacheManager()

    private init() {}

    enum ApiServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedToParseJson
    }

    public func execute<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
        /// Accessing from cache first
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            print("Accessing api data from cache")
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                return result
            } catch {
                throw ApiServiceError.failedToParseJson
            }
        }

        guard let urlRequest = await self.request(from: request) else { throw ApiServiceError.failedToCreateRequest }

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            do {
                let result = try JSONDecoder().decode(type.self, from: data)

                /// Setting cache for this endpoint
                cacheManager.setCache(for: request.endpoint, url: request.url, data: data)

                return result
            } catch {
                throw ApiServiceError.failedToParseJson
            }

        } catch {
            print("APIService Execute Failed", error)
            throw ApiServiceError.failedToGetData
        }
    }

//    public func executeForCodable<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
//        guard let urlRequest = await self.request(from: request) else { throw ApiServiceError.failedToCreateRequest }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: urlRequest)
//            do {
//                let result = try JSONDecoder().decode(type.self, from: data)
//                return result
//            } catch {
//                throw ApiServiceError.failedToParseJson
//            }
//
//        } catch {
//            throw ApiServiceError.failedToGetData
//        }
//    }

    private func request(from apiRequest: ApiRequest) async -> URLRequest? {
        guard let url = apiRequest.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod

        return request
    }
}
