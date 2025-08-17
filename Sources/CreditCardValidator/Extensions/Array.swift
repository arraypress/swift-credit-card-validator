//
//  Array.swift
//  CreditCardValidator
//
//  Created by David Sherlock on 17/08/2025.
//

import Foundation

public extension Array where Element == String {
    
    /// Filter array to only valid credit card numbers.
    var validCreditCards: [String] {
        return filter { $0.isValidCreditCard }
    }
    
    /// Group credit cards by their card type.
    var groupedByCardType: [CardType: [String]] {
        var grouped: [CardType: [String]] = [:]
        for card in self {
            if let type = card.creditCardType {
                grouped[type, default: []].append(card)
            }
        }
        return grouped
    }
    
    /// Get masked versions of all credit cards.
    var maskedCreditCards: [String] {
        return compactMap { $0.maskedCreditCard }
    }
}
