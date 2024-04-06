
import Foundation

/// Primary API Service object to get Rick and Morty Data
final class ApiService {
    static let shared = ApiService()

    private init() {}

    enum ApiServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedToParseJson
    }

    public func execute<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
        guard let urlRequest = await self.request(from: request) else { throw ApiServiceError.failedToCreateRequest }

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                return result
            } catch {
                throw ApiServiceError.failedToParseJson
            }

        } catch {
            print("APIService Execute Failed", error)
            throw ApiServiceError.failedToGetData
        }
    }

    public func executeForCodable<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
        guard let urlRequest = await self.request(from: request) else { throw ApiServiceError.failedToCreateRequest }

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                return result
            } catch {
                throw ApiServiceError.failedToParseJson
            }

        } catch {
            throw ApiServiceError.failedToGetData
        }
    }

    private func request(from apiRequest: ApiRequest) async -> URLRequest? {
        guard let url = apiRequest.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod

        return request
    }
}
