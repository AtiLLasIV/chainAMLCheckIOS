//
//  AddressValidator.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation


enum AddressValidator {
    enum ValidationError: LocalizedError {
        case empty
        case missingPrefix
        case wrongLength(Int)
        case invalidCharacters
        
        
        var errorDescription: String? {
            switch self {
            case .empty:
                return "Адрес не может быть пустым"
            case .missingPrefix:
                return "Адрес должен начинаться с 0x"
            case .wrongLength(let count):
                return "Адрес должен содержать 40 символов, сейчас \(count)"
            case .invalidCharacters:
                return "Адрес может содержать только 0-9 и a-f"
            }
        }
        
    }
    
    static func normalize(_ input: String, for chain: Chain) throws -> String {
        let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { throw ValidationError.empty }
        
        switch chain {
        case .ethereum:
            guard value.lowercased().hasPrefix("0x") else { throw ValidationError.missingPrefix }
            let hex = value.dropFirst(2)
            guard hex.count == 40 else { throw ValidationError.wrongLength(hex.count) }
            guard hex.allSatisfy(\.isHexDigit) else { throw ValidationError.invalidCharacters }
            return "0x" + hex.lowercased()
        }
    }
}

