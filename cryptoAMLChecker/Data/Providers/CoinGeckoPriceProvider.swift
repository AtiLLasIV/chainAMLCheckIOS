import Foundation

struct CoinGeckoPriceProvider: PriceProvider {
    var client = HTTPClient()

    func usdPrice(for chain: Chain) async throws -> Decimal {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/simple/price")
        components?.queryItems = [
            URLQueryItem(name: "ids", value: chain.coingeckoId),
            URLQueryItem(name: "vs_currencies", value: "usd")
        ]
        guard let url = components?.url else { throw NetworkError.badURL }

        let response: [String: [String: Decimal]] = try await client.get(url)
        guard let price = response[chain.coingeckoId]?["usd"] else {
            throw NetworkError.api("Ошибка: не удалось получить цену для \(chain.symbol)")
        }
        return price
    }
}
