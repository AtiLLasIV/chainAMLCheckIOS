import Foundation
import Observation

@MainActor
@Observable
final class ResultViewModel {
    
    enum ProviderState {
        case loading
        case loaded(RiskCheck)
        case failed(String)
        
        var check: RiskCheck? {
            if case .loaded(let check) = self {
                return check
            }
            return nil
        }
    }
    
    
    struct ProviderRow: Identifiable {
        let id: String
        var state: ProviderState
    }
    
    enum BalanceState {
        case loading
        case loaded(Balance)
        case failed(String)
    }

    private(set) var balanceState: BalanceState = .loading
    private let balanceProvider: BalanceProvider
    private let priceProvider: PriceProvider
    
    let request: CheckRequest
    private let providers: [RiskProvider]
    private(set) var rows: [ProviderRow]
    
    init(request: CheckRequest,
         providers: [RiskProvider] = [GoPlusProvider(), TRMSanctionsProvider()],
         balanceProvider: BalanceProvider = MultiChainBalanceProvider(),
         priceProvider: PriceProvider = CoinGeckoPriceProvider()) {
        self.request = request
        self.providers = providers
        self.balanceProvider = balanceProvider
        self.priceProvider = priceProvider
        self.rows = providers.map { ProviderRow(id: $0.name, state: .loading) }
    }
    
    var overallLevel: RiskLevel? {
        rows.compactMap(\.state.check).map(\.level).max()
    }
    
    func load() async {
        async let risks: Void = loadRisks()
        async let balance: Void = loadBalance()
        await risks
        await balance
    }
    
    private func loadRisks() async {
        for index in rows.indices {
            rows[index].state = .loading
        }
        
        let address = request.address
        let chain = request.chain
        
        await withTaskGroup(of: (Int, ProviderState).self) { group in
            for (index, provider) in providers.enumerated() {
                group.addTask {
                    do {
                        let check = try await provider.check(address: address, chain: chain)
                        return (index, .loaded(check))
                    } catch {
                        return (index, .failed(error.localizedDescription))
                    }
                }
            }
            for await (index, state) in group {
                rows[index].state = state
            }
        }
    }
    
    private func loadBalance() async {
        balanceState = .loading
        do {
            let amount = try await balanceProvider.balance(address: request.address, chain: request.chain)
            let price = try? await priceProvider.usdPrice(for: request.chain)
            balanceState = .loaded(Balance(amount: amount, usdValue: price.map { $0 * amount }))
        } catch {
            balanceState = .failed(error.localizedDescription)
        }
    }
}
