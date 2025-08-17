# Swift Credit Card Validator

A comprehensive credit card validation library for Swift using the Luhn algorithm, supporting all major card networks with type detection, formatting, and masking utilities.

## Features

- ✅ **Luhn algorithm validation** - Industry-standard checksum verification
- ✅ **8 card networks supported** - Visa, Mastercard, Amex, Discover, JCB, UnionPay, Diners Club, Maestro
- ✅ **Card type detection** - Automatic identification from card number
- ✅ **Smart formatting** - Network-specific spacing patterns
- ✅ **Secure masking** - Show only last 4 digits for display
- ✅ **Expiry validation** - MM/YY and MM/YYYY format support
- ✅ **CVV/CVC validation** - Network-specific length validation
- ✅ **2-series Mastercard** - Support for new 2221-2720 range
- ✅ **Extended Visa** - Support for 13, 16, and 19-digit cards
- ✅ **Zero dependencies** - Pure Swift implementation
- ✅ **High performance** - Optimized validation algorithms
- ✅ **Thread-safe** - No shared mutable state
- ✅ **Comprehensive tests** - 24+ test cases with edge cases

## Installation

### Swift Package Manager

Add CreditCardValidator to your project using Xcode:

1. File → Add Package Dependencies
2. Enter: `https://github.com/arraypress/swift-credit-card-validator`
3. Select your desired version

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-credit-card-validator", from: "1.0.0")
]
```

## Quick Start

```swift
import CreditCardValidator

// Basic validation
"4111111111111111".isValidCreditCard     // true (Visa)
"5105105105105100".isValidCreditCard     // true (Mastercard)
"378282246310005".isValidCreditCard      // true (Amex)

// Card type detection
"4111111111111111".creditCardType        // .visa
"5105105105105100".creditCardType        // .mastercard
"378282246310005".creditCardType         // .amex

// Formatting
"4111111111111111".formattedCreditCard   // "4111 1111 1111 1111"
"378282246310005".formattedCreditCard    // "3782 822463 10005"

// Masking for secure display
"4111111111111111".maskedCreditCard      // "**** **** **** 1111"
"378282246310005".maskedCreditCard       // "**** ****** *0005"

// Expiry validation
"12/25".isValidCardExpiry                // true
"01/20".isValidCardExpiry                // false (expired)

// CVV validation
"123".isValidCVV(for: .visa)             // true (3 digits)
"1234".isValidCVV(for: .amex)            // true (4 digits for Amex)
```

## Core APIs

### String Extensions

#### `isValidCreditCard: Bool`
Validates the credit card number using the Luhn algorithm.

```swift
"4532015112830366".isValidCreditCard   // true
"4532015112830367".isValidCreditCard   // false (bad checksum)
"1234567890123456".isValidCreditCard   // false (invalid prefix)
```

#### `creditCardType: CardType?`
Detects the card network from the number.

```swift
"4111111111111111".creditCardType      // .visa
"2223003122003222".creditCardType      // .mastercard (2-series)
"6011111111111117".creditCardType      // .discover
```

#### `creditCardInfo: CreditCardInfo?`
Returns comprehensive card information.

```swift
let info = "4111111111111111".creditCardInfo
// info.type: .visa
// info.lastFourDigits: "1111"
// info.firstSixDigits: "411111" (BIN)
// info.isValid: true
// info.length: 16
```

#### `formattedCreditCard: String?`
Formats the card number with proper spacing.

```swift
"4111111111111111".formattedCreditCard   // "4111 1111 1111 1111"
"378282246310005".formattedCreditCard    // "3782 822463 10005"
```

#### `maskedCreditCard: String?`
Returns masked version showing only last 4 digits.

```swift
"4111111111111111".maskedCreditCard      // "**** **** **** 1111"
```

#### `isValidCardExpiry: Bool`
Validates expiry date in MM/YY or MM/YYYY format.

```swift
"12/25".isValidCardExpiry                // true
"12/2025".isValidCardExpiry              // true
"13/25".isValidCardExpiry                // false (invalid month)
```

#### `isValidCVV(for:) -> Bool`
Validates CVV for specific card type.

```swift
"123".isValidCVV(for: .visa)             // true
"1234".isValidCVV(for: .amex)            // true
"12".isValidCVV(for: .visa)              // false (too short)
```

### Supported Card Types

```swift
enum CardType {
    case visa           // Starts with 4
    case mastercard     // 51-55, 2221-2720
    case amex          // 34, 37
    case discover      // 6011, 65, 644-649, 622126-622925
    case dinersClub    // 300-305, 309, 36, 38
    case jcb           // 3528-3589
    case unionPay      // 62
    case maestro       // 50, 56-58, 63, 67, 6759-6769
}
```

### Array Extensions

#### `validCreditCards: [String]`
Filters array to only valid credit card numbers.

```swift
let cards = ["4111111111111111", "invalid", "5105105105105100"]
cards.validCreditCards  // ["4111111111111111", "5105105105105100"]
```

#### `groupedByCardType: [CardType: [String]]`
Groups credit cards by their network.

```swift
let cards = ["4111111111111111", "4532015112830366", "5105105105105100"]
cards.groupedByCardType
// [.visa: ["4111111111111111", "4532015112830366"], 
//  .mastercard: ["5105105105105100"]]
```

#### `maskedCreditCards: [String]`
Returns masked versions of all cards.

```swift
let cards = ["4111111111111111", "5105105105105100"]
cards.maskedCreditCards  // ["**** **** **** 1111", "**** **** **** 5100"]
```

## Advanced Usage

### Direct Validator Access

```swift
// Validate with explicit type checking
let isValid = CreditCardValidator.validate("4111111111111111")

// Detect card type
let type = CreditCardValidator.detectType("4111111111111111")

// Format with specific type
let formatted = CreditCardValidator.format("4111111111111111", type: .visa)

// Custom mask character
let masked = CreditCardValidator.mask("4111111111111111", type: .visa, maskCharacter: "•")
// Result: "•••• •••• •••• 1111"

// Validate expiry
let validExpiry = CreditCardValidator.validateExpiry("12/25")

// Validate CVV
let validCVV = CreditCardValidator.validateCVV("123", type: .visa)
```

### Test Card Numbers

```swift
// Generate valid test numbers (for testing only)
CreditCardValidator.generateTestNumber(for: .visa)        // "4532015112830366"
CreditCardValidator.generateTestNumber(for: .mastercard)  // "5425233430109903"
CreditCardValidator.generateTestNumber(for: .amex)        // "374245455400126"
CreditCardValidator.generateTestNumber(for: .discover)    // "6011000991300009"
```

## Card Number Formats

### Length Requirements

| Card Type | Valid Lengths |
|-----------|--------------|
| Visa | 13, 16, 19 |
| Mastercard | 16 |
| American Express | 15 |
| Discover | 16, 19 |
| Diners Club | 14, 16, 19 |
| JCB | 16, 17, 18, 19 |
| UnionPay | 16, 17, 18, 19 |
| Maestro | 12-19 |

### CVV/CVC Requirements

| Card Type | CVV Length |
|-----------|------------|
| American Express | 4 digits |
| All Others | 3 digits |

### Formatting Patterns

| Card Type | Format Pattern |
|-----------|---------------|
| Visa/Mastercard | XXXX XXXX XXXX XXXX |
| American Express | XXXX XXXXXX XXXXX |
| Diners Club | XXXX XXXXXX XXXX |

## Examples

### Payment Form Validation

```swift
struct PaymentValidator {
    func validatePayment(number: String, expiry: String, cvv: String) -> Bool {
        // Validate card number
        guard number.isValidCreditCard else {
            showError("Invalid card number")
            return false
        }
        
        // Get card type
        guard let cardType = number.creditCardType else {
            showError("Card type not recognized")
            return false
        }
        
        // Validate expiry
        guard expiry.isValidCardExpiry else {
            showError("Card has expired")
            return false
        }
        
        // Validate CVV for card type
        guard cvv.isValidCVV(for: cardType) else {
            showError("Invalid CVV for \(cardType.rawValue)")
            return false
        }
        
        return true
    }
}
```

### Secure Display

```swift
struct CardDisplay {
    func displayCard(_ number: String) -> String {
        guard let info = number.creditCardInfo else {
            return "Invalid Card"
        }
        
        return """
        Type: \(info.type.rawValue)
        Number: \(number.maskedCreditCard ?? "****")
        Valid: \(info.isValid ? "✓" : "✗")
        """
    }
}
```

### Batch Processing

```swift
func processCards(_ cards: [String]) {
    let validCards = cards.validCreditCards
    let grouped = validCards.groupedByCardType
    
    print("Processing \(validCards.count) valid cards")
    
    for (type, numbers) in grouped {
        print("\(type.rawValue): \(numbers.count) cards")
        let masked = numbers.compactMap { $0.maskedCreditCard }
        masked.forEach { print("  - \($0)") }
    }
}
```

### Input Formatting

```swift
class CardNumberFormatter {
    func format(input: String) -> String {
        let cleaned = input.filter { $0.isNumber }
        
        guard let type = cleaned.creditCardType else {
            // Default formatting if type unknown
            return cleaned.enumerated().map { index, char in
                index > 0 && index % 4 == 0 ? " \(char)" : String(char)
            }.joined()
        }
        
        return CreditCardValidator.format(cleaned, type: type)
    }
}
```

## Security Considerations

- **Never log or store** unmasked credit card numbers
- **Always use HTTPS** when transmitting card data
- **PCI Compliance** - This library helps with validation but doesn't handle PCI compliance
- **Token Usage** - Consider using payment tokens instead of real card numbers
- **Testing** - Use provided test card numbers, never real cards

## Performance

The library is optimized for performance:

- **Single validation**: ~0.006ms per card
- **Type detection**: ~0.001ms per card
- **Luhn algorithm**: ~0.005ms per validation
- **Batch processing**: ~0.005ms per card in arrays
- **Zero allocations** for failed validations

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 13.0+

## Test Coverage

The library includes comprehensive test coverage:
- 24+ test cases
- All major card types validated
- Edge cases handled (spaces, dashes, invalid formats)
- Performance benchmarks
- Thread safety verified

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

CreditCardValidator is available under the MIT license. See LICENSE for details.

## Credits

Built with Swift best practices to provide reliable credit card validation for payment processing applications.
