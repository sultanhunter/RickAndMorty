
import Foundation

final class ApiRequest {
    private enum Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    private let endpoint: ApiEndpoint
    private let pathComponents: Set<String>
    private let queryParameters: [URLQueryItem]

    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            string += argumentString
        }
        return string
    }

    public let httpMethod = "GET"

    public var url: URL? {
        return URL(string: urlString)
    }

    public init(endpoint: ApiEndpoint, pathComponents: Set<String>? = nil, queryParameters: [URLQueryItem]? = nil) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents ?? []
        self.queryParameters = queryParameters ?? []
    }
}
