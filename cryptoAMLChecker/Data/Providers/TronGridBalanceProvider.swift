import Foundation

struct TronGridBalanceProvider: BalanceProvider {
    var client = HTTPClient()

    func balance(address: String, chain: Chain) async throws -> Decimal {
        guard let url = URL(string: "https://api.trongrid.io/v1/accounts/\(address)") else {
            throw NetworkError.badURL
        }

        let response: TronGridResponse = try await client.get(url)
        guard response.success else { throw NetworkError.api("TronGrid вернул ошибку") }

        let sun = response.data?.first?.balance ?? 0
        return Decimal(sun) / pow(10, chain.decimals)
    }
}

private struct TronGridResponse: Decodable {
    let success: Bool
    let data: [Account]?

    struct Account: Decodable {
        let balance: Int?
    }
}
