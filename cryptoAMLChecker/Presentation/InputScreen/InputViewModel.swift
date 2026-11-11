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
    
}
