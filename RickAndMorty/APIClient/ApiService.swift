
import Foundation

/// Primary API Service object to get Rick and Morty Data
final class ApiService {
    static let shared = ApiService()

    private init() {}

    public func execute<T: Codable>(_ request: ApiRequest, expecting type: T.Type) async throws -> T {
        
    }
}
