import Foundation

protocol NetworkConfigurationProtocol {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParms : [String: String] { get }
}

/// Please Look at the Docs: https://developer.themoviedb.org/docs/authentication-application
/// -- request GET \
/// -- url 'https://api.themoviedb.org/3/movie/11' \
/// -- header 'Authorization: Bearer ACCESS_TOKEN'
struct NetworkConfiguration: NetworkConfigurationProtocol {
    let baseURL: URL
    let headers: [String: String]
    let queryParms : [String: String]

    init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParms : [String: String] = [:]
    )
    {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParms = queryParms
    }
}
