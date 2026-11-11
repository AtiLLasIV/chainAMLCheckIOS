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
        
        var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }
    
    
    struct ProviderRow: Identifiable {
        let id: String
        var state: ProviderState
    }
    
    let request: CheckRequest
    private let providers: [RiskProvider]
    private(set) var rows: [ProviderRow]
    
    init(request: CheckRequest, providers: [RiskProvider] = [GoPlusProvider()]) {
        self.request = request
        self.providers = providers
        self.rows = providers.map { ProviderRow(id: $0.name, state: .loading) }
    }
    
    var overallLevel: RiskLevel? {
        rows.compactMap(\.state.check).map(\.level).max()
    }
    
    var isLoading: Bool {
        rows.contains { $0.state.isLoading }
    }
    
    func load() async {
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
    
}
