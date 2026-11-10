//
//  RiskProvider.swift
//  cryptoAMLChecker
//
//  Created by Артём Сороко on 10.11.26.
//

import Foundation

protocol RiskProvider {
    var name: String { get }
    func check(address: String, chain: Chain) async throws -> RiskCheck
}
