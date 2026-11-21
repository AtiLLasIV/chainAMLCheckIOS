import Foundation
import Observation

@MainActor
@Observable
final class InputViewModel {
    var addressText: String = ""
    var chain: Chain = .ethereum
    var errorMessage: String?
    var request: CheckRequest?
    
    func submit() {
        do {
            let address = try AddressValidator.normalize(addressText, for: chain)
            errorMessage = nil
            request = CheckRequest(address: address, chain: chain)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fillExample(_ address: String) {
        addressText = address
        errorMessage = nil
    }
    
    struct Example: Identifiable {
        let title: String
        let address: String
        var id: String { address }
    }

    var examples: [Example] {
        switch chain {
        case .ethereum:
            [Example(title: "vitalik.eth", address: "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"),
             Example(title: "Ronin exploiter (Lazarus)", address: "0x098B716B8Aaf21512996dC57EB0615e2383E2f96")]
        case .tron:
            [Example(title: "Контракт USDT (TRC-20)", address: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t")]
        }
    }
    
}
