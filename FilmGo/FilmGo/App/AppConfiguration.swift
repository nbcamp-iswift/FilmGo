import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL is not defined in Info.plist")
        }
        return apiBaseURL
    }()
}
