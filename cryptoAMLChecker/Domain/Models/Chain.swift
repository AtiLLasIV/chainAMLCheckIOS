//
//  Chain.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation

enum Chain: String, CaseIterable, Identifiable {
    case ethereum
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .ethereum: return "Ethereum"
        }
    }
    
    var symbol: String {
        switch self {
        case .ethereum: "ETH"
        }
    }
    
    // chain_id для EVM API (GoPlus, Etherscan)
    var evmChainId: Int {
        switch self {
        case .ethereum: 1
        }
    }
    
}
