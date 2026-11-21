import Foundation

enum Chain: String, CaseIterable, Identifiable {
    case ethereum
    case tron

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ethereum: "Ethereum"
        case .tron: "TRON"
        }
    }

    var symbol: String {
        switch self {
        case .ethereum: "ETH"
        case .tron: "TRX"
        }
    }

    var evmChainId: Int? {
        switch self {
        case .ethereum: 1
        case .tron: nil
        }
    }

    var goplusChainId: String {
        switch self {
        case .ethereum: "1"
        case .tron: "tron"
        }
    }

    var decimals: Int {
        switch self {
        case .ethereum: 18
        case .tron: 6
        }
    }

    var coingeckoId: String {
        switch self {
        case .ethereum: "ethereum"
        case .tron: "tron"
        }
    }

    var addressPlaceholder: String {
        switch self {
        case .ethereum: "0x..."
        case .tron: "T..."
        }
    }
}
