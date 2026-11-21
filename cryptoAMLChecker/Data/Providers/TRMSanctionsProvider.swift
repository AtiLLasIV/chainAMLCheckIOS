import Foundation

struct TRMSanctionsProvider: RiskProvider {
    let name = "TRM Labs"
    var client = HTTPClient()
    
    func check(address: String, chain: Chain) async throws -> RiskCheck {
        guard let url = URL(string: "https://api.trmlabs.com/public/v1/sanctions/screening") else {
            throw NetworkError.badURL
        }
        
        let response: [ScreeningResult] = try await client.post(url, body: [ScreeningRequest(address: address)])
        guard let result = response.first else {
            throw NetworkError.api("Пустой ответ")
        }
        
        let flags = result.isSanctioned ? [RiskFlag(id: "trm_sanctioned", title: "Адрес в чёрном списке", level: .critical)] : []
        return RiskCheck(flags: flags)
    }
}

private struct ScreeningRequest: Encodable {
    let address: String
}

private struct ScreeningResult: Decodable {
    let address: String
    let isSanctioned: Bool
}
