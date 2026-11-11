import Foundation

protocol RiskProvider {
    var name: String { get }
    func check(address: String, chain: Chain) async throws -> RiskCheck
}
