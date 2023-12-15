
import Foundation

/// Primary API Service object to get Rick and Morty Data
final class ApiService {
    static let shared = ApiService()

    private init() {}

    enum ApiServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case invalidResponse
    }

    public func execute<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
        guard let urlRequest = self.request(from: request) else { throw ApiServiceError.failedToCreateRequest }

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                return result
            } catch {
                throw ApiServiceError.invalidResponse
            }

        } catch {
            throw ApiServiceError.failedToGetData
        }
    }

    private func request(from apiRequest: ApiRequest) -> URLRequest? {
        guard let url = apiRequest.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod

        return request
    }
}
