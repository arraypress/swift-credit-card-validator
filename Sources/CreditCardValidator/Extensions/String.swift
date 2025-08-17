//
//  String.swift
//  CreditCardValidator
//
//  Created by David Sherlock on 17/08/2025.
//

import Foundation

public extension String {
    
    /// Check if this string is a valid credit card number using Luhn algorithm.
    var isValidCreditCard: Bool {
        return CreditCardValidator.validate(self)
    }
    
    /// Detect the credit card type from the card number.
    var creditCardType: CardType? {
        return CreditCardValidator.detectType(self)
    }
    
    /// Get formatted credit card number with spaces.
    var formattedCreditCard: String? {
        guard let type = creditCardType else { return nil }
        return CreditCardValidator.format(self, type: type)
    }
    
    /// Get masked credit card number showing only last 4 digits.
    var maskedCreditCard: String? {
        guard let type = creditCardType else { return nil }
        return CreditCardValidator.mask(self, type: type)
    }
    
    /// Check if this string is a valid card expiry date (MM/YY or MM/YYYY).
    var isValidCardExpiry: Bool {
        return CreditCardValidator.validateExpiry(self)
    }
    
    /// Check if this string is a valid CVV for the given card type.
    func isValidCVV(for type: CardType) -> Bool {
        return CreditCardValidator.validateCVV(self, type: type)
    }
    
    /// Get comprehensive card information.
    var creditCardInfo: CreditCardInfo? {
        guard let type = creditCardType else { return nil }
        let isValid = isValidCreditCard
        let digits = self.filter { $0.isNumber }
        
        return CreditCardInfo(
            number: digits,
            type: type,
            isValid: isValid,
            lastFourDigits: String(digits.suffix(4)),
            firstSixDigits: String(digits.prefix(6)),
            length: digits.count
        )
    }
    
}
