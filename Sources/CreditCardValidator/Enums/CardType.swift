//
//  CardType.swift
//  CreditCardValidator
//
//  Created by David Sherlock on 17/08/2025.
//

import Foundation

public enum CardType: String, CaseIterable, Sendable {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
    case discover = "Discover"
    case dinersClub = "Diners Club"
    case jcb = "JCB"
    case unionPay = "UnionPay"
    case maestro = "Maestro"
    
    /// Valid card number lengths for this card type
    public var validLengths: [Int] {
        switch self {
        case .visa:
            return [13, 16, 19]
        case .mastercard:
            return [16]
        case .amex:
            return [15]
        case .discover:
            return [16, 19]
        case .dinersClub:
            return [14, 16, 19]
        case .jcb:
            return [16, 17, 18, 19]
        case .unionPay:
            return [16, 17, 18, 19]
        case .maestro:
            return [12, 13, 14, 15, 16, 17, 18, 19]
        }
    }
    
    /// CVV/CVC length for this card type
    public var cvvLength: Int {
        switch self {
        case .amex:
            return 4
        default:
            return 3
        }
    }
    
    /// Display format pattern for this card type
    public var formatPattern: [Int] {
        switch self {
        case .amex:
            return [4, 6, 5]  // XXXX XXXXXX XXXXX
        case .dinersClub:
            return [4, 6, 4]  // XXXX XXXXXX XXXX
        default:
            return [4, 4, 4, 4]  // XXXX XXXX XXXX XXXX
        }
    }
}
