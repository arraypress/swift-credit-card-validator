//
//  CreditCardInfo.swift
//  CreditCardValidator
//
//  Created by David Sherlock on 17/08/2025.
//

import Foundation

public struct CreditCardInfo: Sendable {
    public let number: String
    public let type: CardType
    public let isValid: Bool
    public let lastFourDigits: String
    public let firstSixDigits: String
    public let length: Int
}
