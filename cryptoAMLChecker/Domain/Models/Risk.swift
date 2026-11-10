//
//  Risk.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation

enum RiskLevel: Comparable {
    case clean, warning, high, critical
    
    var title: String {
        switch self {
        case .clean: "Не найден в базах"
        case .warning: "Есть подозрения"
        case .high: "Высокий риск"
        case .critical: "Критический риск"
        }
    }
}

// одна находка от источника
struct RiskFlag: Identifiable, Hashable {
    let id: String
    let title: String
    let level: RiskLevel
}

// ответ источника
struct RiskCheck {
    let flags: [RiskFlag]
    let dataSource: String?
    
    var level: RiskLevel {
        flags.map(\.level).max() ?? .clean
    }
}
