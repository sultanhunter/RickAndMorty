
import Foundation

final class ApiRequest {
    private enum Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    private let endpoint: ApiEndpoint
    private let pathComponents: [String]
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

    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }

        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endPointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndPoint = ApiEndpoint(rawValue: endPointString) {
                    self.init(endpoint: rmEndPoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endPointString = components[0]
                let queryItemsString = components[1]

                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else { return nil }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                if let rmEndPoint = ApiEndpoint(rawValue: endPointString) {
                    self.init(endpoint: rmEndPoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }

    public init(endpoint: ApiEndpoint, pathComponents: [String]? = nil, queryParameters: [URLQueryItem]? = nil) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents ?? []
        self.queryParameters = queryParameters ?? []
    }
}

extension ApiRequest {
    static let listCharactersRequest = ApiRequest(endpoint: .character)
}
