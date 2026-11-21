import Foundation

protocol BalanceProvider {
    func balance(address: String, chain: Chain) async throws -> Decimal
}

protocol PriceProvider {
    func usdPrice(for chain: Chain) async throws -> Decimal
}
