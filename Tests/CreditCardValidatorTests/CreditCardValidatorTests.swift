//
//  CreditCardValidatorTests.swift
//  CreditCardValidator
//
//  Comprehensive test suite for credit card validation
//  Testing Luhn algorithm, card type detection, and formatting
//  Created on 26/01/2025.
//

import XCTest
@testable import CreditCardValidator

final class CreditCardValidatorTests: XCTestCase {
    
    // MARK: - Valid Card Number Tests
    
    func testValidVisaNumbers() {
        let validVisa = [
            "4532015112830366",
            "4916338506082832",
            "4556015886206505",
            "4539578763621486",
            "4111111111111111",  // Common test number
            "4012888888881881",  // Another common test number
        ]
        
        for card in validVisa {
            XCTAssertTrue(card.isValidCreditCard, "Should be valid Visa: \(card)")
            XCTAssertEqual(card.creditCardType, .visa, "Should detect Visa: \(card)")
        }
    }
    
    func testValidMastercardNumbers() {
        let validMastercard = [
            "5425233430109903",
            "5555555555554444",  // Test number
            "5105105105105100",  // Test number
            "2223003122003222",  // New 2-series
            "2720990000000007",  // New 2-series
        ]
        
        for card in validMastercard {
            XCTAssertTrue(card.isValidCreditCard, "Should be valid Mastercard: \(card)")
            XCTAssertEqual(card.creditCardType, .mastercard, "Should detect Mastercard: \(card)")
        }
    }
    
    func testValidAmexNumbers() {
        let validAmex = [
            "374245455400126",
            "378282246310005",  // Test number
            "371449635398431",  // Test number
            "378734493671000",  // Corporate test
        ]
        
        for card in validAmex {
            XCTAssertTrue(card.isValidCreditCard, "Should be valid Amex: \(card)")
            XCTAssertEqual(card.creditCardType, .amex, "Should detect Amex: \(card)")
            XCTAssertEqual(card.creditCardInfo?.length, 15, "Amex should be 15 digits")
        }
    }
    
    func testValidDiscoverNumbers() {
        let validDiscover = [
            "6011000991300009",
            "6011111111111117",  // Test number
            "6011500080009080",
            "6011000000000012",  // Valid test number
        ]
        
        for card in validDiscover {
            XCTAssertTrue(card.isValidCreditCard, "Should be valid Discover: \(card)")
            XCTAssertEqual(card.creditCardType, .discover, "Should detect Discover: \(card)")
        }
    }
    
    func testValidJCBNumbers() {
        let validJCB = [
            "3530111333300000",  // Test number
            "3566002020360505",  // Test number
            "3528000000000007",
        ]
        
        for card in validJCB {
            XCTAssertTrue(card.isValidCreditCard, "Should be valid JCB: \(card)")
            XCTAssertEqual(card.creditCardType, .jcb, "Should detect JCB: \(card)")
        }
    }
    
    // MARK: - Invalid Card Number Tests
    
    func testInvalidCardNumbers() {
        let invalidCards = [
            "4532015112830367",  // Invalid Luhn check
            "1234567890123456",  // Invalid prefix
            "0000000000000000",  // All zeros
            "453201511283036",   // Too short
            "45320151128303661234567890",  // Too long
            "",                   // Empty
            "abcd-efgh-ijkl-mnop",  // Non-numeric
        ]
        
        for card in invalidCards {
            XCTAssertFalse(card.isValidCreditCard, "Should be invalid: \(card)")
        }
    }
    
    func testInvalidLuhnCheck() {
        // These have valid prefixes but fail Luhn check
        let invalidLuhn = [
            "4111111111111112",  // Visa prefix, bad Luhn
            "5105105105105101",  // Mastercard prefix, bad Luhn
            "378282246310006",   // Amex prefix, bad Luhn
        ]
        
        for card in invalidLuhn {
            XCTAssertFalse(card.isValidCreditCard, "Should fail Luhn check: \(card)")
        }
    }
    
    // MARK: - Card Type Detection Tests
    
    func testCardTypeDetection() {
        let testCases: [(String, CardType)] = [
            ("4111111111111111", .visa),
            ("5500000000000004", .mastercard),
            ("2223000000000007", .mastercard),  // New 2-series
            ("340000000000009", .amex),
            ("6011000000000004", .discover),
            ("3528000000000007", .jcb),
            ("6200000000000005", .unionPay),
            ("5018000000000009", .maestro),
        ]
        
        for (number, expectedType) in testCases {
            XCTAssertEqual(number.creditCardType, expectedType,
                           "Wrong type for \(number), expected \(expectedType)")
        }
    }
    
    // MARK: - Formatting Tests
    
    func testCardFormatting() {
        XCTAssertEqual("4111111111111111".formattedCreditCard, "4111 1111 1111 1111")
        XCTAssertEqual("378282246310005".formattedCreditCard, "3782 822463 10005")
        XCTAssertEqual("5105105105105100".formattedCreditCard, "5105 1051 0510 5100")
    }
    
    func testCardFormattingWithSpaces() {
        // Should handle input with spaces
        XCTAssertEqual("4111 1111 1111 1111".formattedCreditCard, "4111 1111 1111 1111")
        XCTAssertEqual("3782 8224 6310 005".formattedCreditCard, "3782 822463 10005")
    }
    
    // MARK: - Masking Tests
    
    func testCardMasking() {
        XCTAssertEqual("4111111111111111".maskedCreditCard, "**** **** **** 1111")
        XCTAssertEqual("378282246310005".maskedCreditCard, "**** ****** *0005")
        XCTAssertEqual("5105105105105100".maskedCreditCard, "**** **** **** 5100")
    }
    
    // MARK: - Expiry Validation Tests
    
    func testValidExpiry() {
        let futureMonth = Calendar.current.component(.month, from: Date()) + 1
        let futureYear = Calendar.current.component(.year, from: Date()) % 100
        
        XCTAssertTrue("12/99".isValidCardExpiry, "Should be valid future expiry")
        XCTAssertTrue("\(String(format: "%02d", futureMonth))/\(futureYear)".isValidCardExpiry)
        XCTAssertTrue("12/2099".isValidCardExpiry, "Should handle 4-digit year")
    }
    
    func testInvalidExpiry() {
        XCTAssertFalse("13/25".isValidCardExpiry, "Invalid month")
        XCTAssertFalse("00/25".isValidCardExpiry, "Invalid month")
        XCTAssertFalse("01/20".isValidCardExpiry, "Past expiry")
        XCTAssertFalse("12/19".isValidCardExpiry, "Past expiry")
        XCTAssertFalse("1225".isValidCardExpiry, "Missing separator")
        XCTAssertFalse("".isValidCardExpiry, "Empty expiry")
    }
    
    // MARK: - CVV Validation Tests
    
    func testCVVValidation() {
        // Visa/Mastercard/Discover use 3-digit CVV
        XCTAssertTrue("123".isValidCVV(for: .visa))
        XCTAssertTrue("000".isValidCVV(for: .mastercard))
        XCTAssertTrue("999".isValidCVV(for: .discover))
        
        // Amex uses 4-digit CVV
        XCTAssertTrue("1234".isValidCVV(for: .amex))
        XCTAssertTrue("0000".isValidCVV(for: .amex))
        
        // Invalid CVVs
        XCTAssertFalse("12".isValidCVV(for: .visa), "Too short")
        XCTAssertFalse("1234".isValidCVV(for: .visa), "Too long for Visa")
        XCTAssertFalse("123".isValidCVV(for: .amex), "Too short for Amex")
        XCTAssertFalse("abc".isValidCVV(for: .visa), "Non-numeric")
    }
    
    // MARK: - Card Info Tests
    
    func testCreditCardInfo() {
        let info = "4111111111111111".creditCardInfo
        
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.type, .visa)
        XCTAssertEqual(info?.lastFourDigits, "1111")
        XCTAssertEqual(info?.firstSixDigits, "411111")
        XCTAssertEqual(info?.length, 16)
        XCTAssertTrue(info?.isValid ?? false)
    }
    
    // MARK: - Array Extension Tests
    
    func testArrayValidCards() {
        let cards = [
            "4111111111111111",  // Valid Visa
            "invalid",
            "5105105105105100",  // Valid Mastercard
            "1234567890123456",  // Invalid
        ]
        
        let validCards = cards.validCreditCards
        XCTAssertEqual(validCards.count, 2)
        XCTAssertTrue(validCards.contains("4111111111111111"))
        XCTAssertTrue(validCards.contains("5105105105105100"))
    }
    
    func testArrayGroupByType() {
        let cards = [
            "4111111111111111",  // Visa
            "4532015112830366",  // Visa
            "5105105105105100",  // Mastercard
            "378282246310005",   // Amex
        ]
        
        let grouped = cards.groupedByCardType
        XCTAssertEqual(grouped[.visa]?.count, 2)
        XCTAssertEqual(grouped[.mastercard]?.count, 1)
        XCTAssertEqual(grouped[.amex]?.count, 1)
    }
    
    func testArrayMasking() {
        let cards = [
            "4111111111111111",
            "5105105105105100",
        ]
        
        let masked = cards.maskedCreditCards
        XCTAssertEqual(masked.count, 2)
        XCTAssertTrue(masked.contains("**** **** **** 1111"))
        XCTAssertTrue(masked.contains("**** **** **** 5100"))
    }
    
    // MARK: - Edge Cases
    
    func testWhitespaceHandling() {
        let cardWithSpaces = "  4111 1111 1111 1111  "
        XCTAssertTrue(cardWithSpaces.isValidCreditCard)
        XCTAssertEqual(cardWithSpaces.creditCardType, .visa)
    }
    
    func testDashHandling() {
        let cardWithDashes = "4111-1111-1111-1111"
        XCTAssertTrue(cardWithDashes.isValidCreditCard)
        XCTAssertEqual(cardWithDashes.creditCardType, .visa)
    }
    
    func testMixedSeparators() {
        let cardMixed = "4111 1111-1111.1111"
        XCTAssertTrue(cardMixed.isValidCreditCard)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceValidation() {
        let card = "4111111111111111"
        
        measure {
            for _ in 0..<1000 {
                _ = card.isValidCreditCard
            }
        }
    }
    
    func testPerformanceTypeDetection() {
        let card = "4111111111111111"
        
        measure {
            for _ in 0..<1000 {
                _ = card.creditCardType
            }
        }
    }
    
    func testPerformanceLuhnAlgorithm() {
        let card = "4111111111111111"
        
        measure {
            for _ in 0..<1000 {
                _ = CreditCardValidator.validate(card)
            }
        }
    }
    
}
