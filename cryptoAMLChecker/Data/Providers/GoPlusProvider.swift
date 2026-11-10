//
//  GoPlusProvider.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation

struct GoPlusProvider: RiskProvider {
    let name = "GoPlus"
    var client = HTTPClient()
    
    private static let flagMap: [String: (title: String, level: RiskLevel)] = [
        "sanctioned": ("Под санкциями", .critical),
        "money_laundering": ("Отмывание денег", .critical),
        "cybercrime": ("Киберпреступность", .critical),
        "stealing_attack": ("Кража средств", .critical),
        "financial_crime": ("Финансовые преступления", .critical),
        "darkweb_transactions": ("Транзакции в даркнете", .critical),
        "mixer": ("Связаны с миксерами", .critical),
        "phishing_activities": ("Фишинг", .high),
        "blackmail_activities": ("Связаны с вымогательствами", .high),
        "fake_kyc": ("Поддельный KYC (проверка личности)", .high),
        "honeypot_related_address": ("Связан с honeypot-токенами", .high),
        "malicious_mining_activities": ("Вредоносный майнинг", .high),
        "fake_token": ("Поддельный токен", .high),
        "fake_standard_interface": ("Поддельный стандарт токена", .high),
        "blacklist_doubt": ("Подозрение на чёрный список", .warning),
        "gas_abuse": ("Злоупотребление газом", .warning),
        "reinit": ("Переразвёртываемый контракт", .warning)
    ]
    
    func check(address: String, chain: Chain) async throws -> RiskCheck {
        var components = URLComponents(string: "https://api.gopluslabs.io/api/v1/address_security/\(address)")
        components?.queryItems = [URLQueryItem(name: "chain_id", value: String(chain.evmChainId))]
        guard let url = components?.url else { throw NetworkError.badURL }
        
        let response: GoPlusResponse = try await client.get(url)
        
        guard response.code == 1, let result = response.result else {
            throw NetworkError.api(response.message)
        }
        
        var flags: [RiskFlag] = Self.flagMap.compactMap { key, info in
            guard result[key]?.isTrue == true else { return nil }
            return RiskFlag(id: key, title: info.title, level: info.level)
        }
        
        if let created = result["number_of_malicious_contracts_created"]?.intValue, created > 0 {
            flags.append(RiskFlag(id: "malicious_contracts",
                                  title: "Создал вредоносных контрактов: \(created)",
                                  level: .high))
        }
        
        flags.sort { $0.level > $1.level }
        
        let source = result["data_source"]?.text
        return RiskCheck(flags: flags, dataSource: (source?.isEmpty ?? true) ? nil : source)
    }
}

private struct GoPlusResponse: Decodable {
    let code: Int
    let message: String
    let result: [String: LooseValue]?
}

private enum LooseValue: Decodable {
    case string(String)
    case number(Double)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let s = try? container.decode(String.self) {
            self = .string(s)
        } else if let d = try? container.decode(Double.self) {
            self = .number(d)
        } else {
            self = .null
        }
    }
    
    var intValue: Int? {
        switch self {
        case .null: return nil
        case .string(let s): return Int(s)
        case .number(let d): return Int(d)
        }
    }
    
    var isTrue: Bool { (intValue ?? 0) > 0 }
    
    var text: String? {
        if case .string(let s) = self { return s }
        return nil
    }
}
