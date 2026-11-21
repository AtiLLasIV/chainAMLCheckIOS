import Foundation

enum AddressValidator {

    enum ValidationError: LocalizedError {
        case empty
        case missingPrefix(String)
        case wrongLength(expected: Int, actual: Int)
        case invalidCharacters

        var errorDescription: String? {
            switch self {
            case .empty: "Адрес не может быть пустым"
            case .missingPrefix(let prefix): "Адрес должен начинаться с \(prefix)"
            case .wrongLength(let expected, let actual): "Адрес должен содержать \(expected) символов, сейчас \(actual)"
            case .invalidCharacters: "Адрес содержит недопустимые символы"
            }
        }
    }

    private static let base58 = Set("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

    static func normalize(_ input: String, for chain: Chain) throws -> String {
        let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { throw ValidationError.empty }

        switch chain {
        case .ethereum:
            guard value.lowercased().hasPrefix("0x") else { throw ValidationError.missingPrefix("0x") }
            let hex = value.dropFirst(2)
            guard hex.count == 40 else { throw ValidationError.wrongLength(expected: 42, actual: value.count) }
            guard hex.allSatisfy(\.isHexDigit) else { throw ValidationError.invalidCharacters }
            return "0x" + hex.lowercased()

        case .tron:
            guard value.hasPrefix("T") else { throw ValidationError.missingPrefix("T") }
            guard value.count == 34 else { throw ValidationError.wrongLength(expected: 34, actual: value.count) }
            guard value.allSatisfy({ base58.contains($0) }) else { throw ValidationError.invalidCharacters }
            return value
        }
    }
}
