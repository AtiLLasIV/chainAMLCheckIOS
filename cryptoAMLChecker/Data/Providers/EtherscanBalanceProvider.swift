import Foundation

struct EtherscanBalanceProvider: BalanceProvider {
    var client = HTTPClient()
    var apiKey = AppSecrets.etherscanAPIKey

    func balance(address: String, chain: Chain) async throws -> Decimal {
        guard let chainId = chain.evmChainId else {
            throw NetworkError.api("Etherscan не поддерживает \(chain.title)")
        }
        
        var components = URLComponents(string: "https://api.etherscan.io/v2/api")
        components?.queryItems = [
            URLQueryItem(name: "chainid", value: String(chainId)),
            URLQueryItem(name: "module", value: "account"),
            URLQueryItem(name: "action", value: "balance"),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "tag", value: "latest"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        guard let url = components?.url else { throw NetworkError.badURL }

        let response: EtherscanResponse = try await client.get(url)

        guard response.status == "1", let wei = Decimal(string: response.result) else {
            throw NetworkError.api(response.result)
        }
        return wei / pow(10, chain.decimals)
    }
}

private struct EtherscanResponse: Decodable {
    let status: String
    let message: String
    let result: String
}
