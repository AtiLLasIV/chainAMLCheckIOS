//
//  HTTPClient.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case badStatus(Int)
    case decoding(Error)
    case api(String)
    
    var errorDescription: String? {
        switch self {
        case .badURL: "Некорректный URL"
        case .badStatus(let code): "Код ответа: \(code)"
        case .decoding: "Не удалось разобрать ответ сервера"
        case .api(let message): "Ошибка API: \(message)"
        }
    }
}

struct HTTPClient {
    var session: URLSession = .shared
    
    func get<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badStatus(-1)
        }
        guard http.statusCode >= 200 && http.statusCode < 300 else {
            throw NetworkError.badStatus(http.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
