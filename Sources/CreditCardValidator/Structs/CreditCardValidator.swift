//
//  CreditCardValidator.swift
//  CreditCardValidator
//
//  Created by David Sherlock on 17/08/2025.
//

import Foundation

public struct CreditCardValidator {
    
    // MARK: - Validation
    
    /// Validate a credit card number using Luhn algorithm.
    ///
    /// Performs comprehensive validation including:
    /// - Length validation (12-19 digits)
    /// - Card type detection
    /// - Type-specific length validation
    /// - Luhn checksum verification
    ///
    /// - Parameter cardNumber: The credit card number to validate
    /// - Returns: true if the card number is valid
    public static func validate(_ cardNumber: String) -> Bool {
        let digits = cardNumber.filter { $0.isNumber }
        
        // Basic length check
        guard digits.count >= 12 && digits.count <= 19 else { return false }
        
        // Detect type and validate length
        guard let type = detectType(digits) else { return false }
        guard type.validLengths.contains(digits.count) else { return false }
        
        // Perform Luhn check
        return luhnCheck(digits)
    }
    
    /// Perform Luhn algorithm check on a card number.
    ///
    /// The Luhn algorithm is a checksum formula used to validate
    /// credit card numbers. It works by:
    /// 1. Starting from the rightmost digit (check digit)
    /// 2. Moving left, double every second digit
    /// 3. If doubling results in a number > 9, subtract 9
    /// 4. Sum all digits
    /// 5. Valid if sum is divisible by 10
    ///
    /// - Parameter number: The card number string (digits only)
    /// - Returns: true if the number passes Luhn validation
    private static func luhnCheck(_ number: String) -> Bool {
        let digits = number.compactMap { $0.wholeNumberValue }
        guard digits.count == number.count else { return false }
        
        var sum = 0
        var alternate = false
        
        for digit in digits.reversed() {
            var d = digit
            if alternate {
                d *= 2
                if d > 9 {
                    d -= 9
                }
            }
            sum += d
            alternate.toggle()
        }
        
        return sum % 10 == 0
    }
    
    // MARK: - Type Detection
    
    /// Detect credit card type from card number.
    ///
    /// Analyzes the card number prefix to determine which card network
    /// issued the card. Supports all major card networks including new
    /// Mastercard 2-series and extended Visa formats.
    ///
    /// - Parameter cardNumber: The credit card number to analyze
    /// - Returns: The detected card type, or nil if no type matches
    public static func detectType(_ cardNumber: String) -> CardType? {
        let digits = cardNumber.filter { $0.isNumber }
        guard !digits.isEmpty else { return nil }
        
        // Check each card type's patterns
        if isVisa(digits) { return .visa }
        if isMastercard(digits) { return .mastercard }
        if isAmex(digits) { return .amex }
        if isDiscover(digits) { return .discover }
        if isDinersClub(digits) { return .dinersClub }
        if isJCB(digits) { return .jcb }
        if isUnionPay(digits) { return .unionPay }
        if isMaestro(digits) { return .maestro }
        
        return nil
    }
    
    /// Check if the card number matches Visa patterns.
    ///
    /// Visa cards always start with 4 and can be 13, 16, or 19 digits.
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Visa patterns
    private static func isVisa(_ number: String) -> Bool {
        return number.hasPrefix("4")
    }
    
    /// Check if the card number matches Mastercard patterns.
    ///
    /// Mastercard uses two ranges:
    /// - Classic: 51-55
    /// - New 2-series: 2221-2720
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Mastercard patterns
    private static func isMastercard(_ number: String) -> Bool {
        guard number.count >= 2 else { return false }
        let prefix = Int(number.prefix(2)) ?? 0
        
        // 51-55 or 2221-2720
        if (51...55).contains(prefix) { return true }
        
        guard number.count >= 4 else { return false }
        let longPrefix = Int(number.prefix(4)) ?? 0
        return (2221...2720).contains(longPrefix)
    }
    
    /// Check if the card number matches American Express patterns.
    ///
    /// Amex cards start with 34 or 37 and are always 15 digits.
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Amex patterns
    private static func isAmex(_ number: String) -> Bool {
        guard number.count >= 2 else { return false }
        let prefix = number.prefix(2)
        return prefix == "34" || prefix == "37"
    }
    
    /// Check if the card number matches Discover patterns.
    ///
    /// Discover uses multiple prefixes:
    /// - 6011
    /// - 65
    /// - 644-649
    /// - 622126-622925
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Discover patterns
    private static func isDiscover(_ number: String) -> Bool {
        guard number.count >= 4 else { return false }
        
        if number.hasPrefix("6011") { return true }
        if number.hasPrefix("65") { return true }
        
        let prefix = Int(number.prefix(3)) ?? 0
        if (644...649).contains(prefix) { return true }
        
        let longPrefix = Int(number.prefix(6)) ?? 0
        return (622126...622925).contains(longPrefix)
    }
    
    /// Check if the card number matches Diners Club patterns.
    ///
    /// Diners Club uses:
    /// - 300-305
    /// - 309
    /// - 36
    /// - 38
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Diners Club patterns
    private static func isDinersClub(_ number: String) -> Bool {
        guard number.count >= 3 else { return false }
        
        let prefix = Int(number.prefix(3)) ?? 0
        if (300...305).contains(prefix) { return true }
        if prefix == 309 { return true }
        
        return number.hasPrefix("36") || number.hasPrefix("38")
    }
    
    /// Check if the card number matches JCB patterns.
    ///
    /// JCB cards use the range 3528-3589.
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches JCB patterns
    private static func isJCB(_ number: String) -> Bool {
        guard number.count >= 4 else { return false }
        let prefix = Int(number.prefix(4)) ?? 0
        return (3528...3589).contains(prefix)
    }
    
    /// Check if the card number matches UnionPay patterns.
    ///
    /// UnionPay cards start with 62.
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches UnionPay patterns
    private static func isUnionPay(_ number: String) -> Bool {
        return number.hasPrefix("62")
    }
    
    /// Check if the card number matches Maestro patterns.
    ///
    /// Maestro uses multiple prefixes:
    /// - 50, 56-58, 63, 67
    /// - 6759-6769
    ///
    /// - Parameter number: The card number digits
    /// - Returns: true if the number matches Maestro patterns
    private static func isMaestro(_ number: String) -> Bool {
        guard number.count >= 2 else { return false }
        
        let prefixes = ["50", "56", "57", "58", "63", "67"]
        for prefix in prefixes {
            if number.hasPrefix(prefix) { return true }
        }
        
        guard number.count >= 4 else { return false }
        let fourDigit = Int(number.prefix(4)) ?? 0
        return (6759...6769).contains(fourDigit)
    }
    
    // MARK: - Formatting
    
    /// Format a credit card number with spaces according to card type.
    ///
    /// Applies the standard formatting pattern for each card type:
    /// - Visa/Mastercard: XXXX XXXX XXXX XXXX
    /// - Amex: XXXX XXXXXX XXXXX
    /// - Diners: XXXX XXXXXX XXXX
    ///
    /// - Parameters:
    ///   - cardNumber: The credit card number to format
    ///   - type: The card type to determine formatting pattern
    /// - Returns: Formatted card number with appropriate spacing
    public static func format(_ cardNumber: String, type: CardType) -> String {
        let digits = cardNumber.filter { $0.isNumber }
        let pattern = type.formatPattern
        
        var formatted = ""
        var index = 0
        
        for groupSize in pattern {
            if index >= digits.count { break }
            
            let endIndex = min(index + groupSize, digits.count)
            let group = String(digits[digits.index(digits.startIndex, offsetBy: index)..<digits.index(digits.startIndex, offsetBy: endIndex)])
            
            if !formatted.isEmpty {
                formatted += " "
            }
            formatted += group
            index = endIndex
        }
        
        return formatted
    }
    
    /// Mask a credit card number showing only last 4 digits.
    ///
    /// Creates a safe display format for credit cards by replacing
    /// all but the last 4 digits with a mask character.
    ///
    /// Examples:
    /// - Visa: **** **** **** 1234
    /// - Amex: **** ****** *1234
    ///
    /// - Parameters:
    ///   - cardNumber: The credit card number to mask
    ///   - type: The card type for proper formatting
    ///   - maskCharacter: Character to use for masking (default: *)
    /// - Returns: Masked and formatted card number
    public static func mask(_ cardNumber: String, type: CardType, maskCharacter: Character = "*") -> String {
        let digits = cardNumber.filter { $0.isNumber }
        guard digits.count >= 4 else { return digits }
        
        let lastFour = String(digits.suffix(4))
        let formatted = format(digits, type: type)
        let components = formatted.split(separator: " ")
        
        var masked = components.dropLast().map { group in
            String(repeating: String(maskCharacter), count: group.count)
        }
        
        if let lastGroup = components.last {
            let maskedCount = lastGroup.count - 4
            let maskedPart = String(repeating: String(maskCharacter), count: max(0, maskedCount))
            masked.append(maskedPart + lastFour)
        }
        
        return masked.joined(separator: " ")
    }
    
    // MARK: - Expiry Validation
    
    /// Validate credit card expiry date (MM/YY or MM/YYYY).
    ///
    /// Accepts expiry dates in MM/YY or MM/YYYY format and validates:
    /// - Month is between 1-12
    /// - Date is not in the past
    /// - Handles 2-digit year conversion intelligently
    ///
    /// - Parameter expiry: Expiry date string (e.g., "12/25" or "12/2025")
    /// - Returns: true if the expiry date is valid and not expired
    public static func validateExpiry(_ expiry: String) -> Bool {
        let cleaned = expiry.filter { $0.isNumber || $0 == "/" }
        
        // Support MM/YY and MM/YYYY formats
        let components = cleaned.split(separator: "/")
        guard components.count == 2 else { return false }
        
        guard let month = Int(components[0]),
              let year = Int(components[1]) else { return false }
        
        // Validate month
        guard (1...12).contains(month) else { return false }
        
        // Convert 2-digit year to 4-digit
        var fullYear: Int
        if year < 100 {
            let currentYear = Calendar.current.component(.year, from: Date())
            let century = (currentYear / 100) * 100
            fullYear = century + year
            
            // Handle century boundary (e.g., 99 could be 1999 or 2099)
            if fullYear < currentYear - 10 {
                fullYear = fullYear + 100
            }
        } else {
            fullYear = year
        }
        
        // Check if expiry is in the future
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        if fullYear > currentYear {
            return true
        } else if fullYear == currentYear {
            return month >= currentMonth
        }
        
        return false
    }
    
    // MARK: - CVV Validation
    
    /// Validate CVV/CVC code for a specific card type.
    ///
    /// Validates the security code based on card type requirements:
    /// - Most cards: 3 digits
    /// - American Express: 4 digits
    ///
    /// - Parameters:
    ///   - cvv: The CVV/CVC code to validate
    ///   - type: The card type to determine required length
    /// - Returns: true if the CVV is valid for the card type
    public static func validateCVV(_ cvv: String, type: CardType) -> Bool {
        let digits = cvv.filter { $0.isNumber }
        return digits.count == type.cvvLength && digits.count == cvv.count
    }
    
    // MARK: - Utility Methods
    
    /// Generate a test credit card number that passes Luhn check (for testing only).
    ///
    /// Provides valid test card numbers for each card type.
    /// These are publicly documented test numbers that will pass
    /// validation but should never be used for real transactions.
    ///
    /// - Warning: These are for testing only. Never use in production.
    /// - Parameter type: The card type to generate a test number for
    /// - Returns: A valid test credit card number
    public static func generateTestNumber(for type: CardType) -> String {
        switch type {
        case .visa:
            return "4532015112830366"  // Test Visa
        case .mastercard:
            return "5425233430109903"  // Test Mastercard
        case .amex:
            return "374245455400126"   // Test Amex
        case .discover:
            return "6011000991300009"  // Test Discover
        case .dinersClub:
            return "36006666333344"    // Test Diners
        case .jcb:
            return "3530111333300000"  // Test JCB
        case .unionPay:
            return "6200000000000005"  // Test UnionPay
        case .maestro:
            return "6759649826438453"  // Test Maestro
        }
    }
    
}
