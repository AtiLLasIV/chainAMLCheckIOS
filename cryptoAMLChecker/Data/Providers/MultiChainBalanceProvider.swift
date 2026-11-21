import Foundation

struct MultiChainBalanceProvider: BalanceProvider {
    var ethereum: BalanceProvider = EtherscanBalanceProvider()
    var tron: BalanceProvider = TronGridBalanceProvider()

    func balance(address: String, chain: Chain) async throws -> Decimal {
        switch chain {
        case .ethereum: return try await ethereum.balance(address: address, chain: chain)
        case .tron: return try await tron.balance(address: address, chain: chain)
        }
    }
}
