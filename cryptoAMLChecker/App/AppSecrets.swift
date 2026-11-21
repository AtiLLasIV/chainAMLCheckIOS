import Foundation

enum AppSecrets {
    static var etherscanAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "EtherscanAPIKey") as? String ?? ""
    }
}
