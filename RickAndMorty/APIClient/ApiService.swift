
import Foundation

/// Primary API Service object to get Rick and Morty Data
final class ApiService {
    static let shared = ApiService()

    private init() {}

    public func execute(_ request: ApiRequest, completion: @escaping () -> Void) {}
}
