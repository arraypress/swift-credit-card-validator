# Swift Credit Card Validator

A comprehensive credit card validation library for Swift built on the Luhn algorithm. It validates card numbers, detects the issuing network from the prefix, formats and masks numbers for display, validates expiry dates and CVV codes, and exposes ergonomic String and Array extensions — supporting all major networks including Visa, Mastercard (2-series), Amex, Discover, Diners Club, JCB, UnionPay, and Maestro.

## Features

- ✅ **Luhn validation** — `validate` checks length, type-specific length, and checksum
- 🏦 **Network detection** — `detectType` identifies the card network from its prefix
- 🎯 **8 card networks** — Visa, Mastercard, Amex, Discover, Diners Club, JCB, UnionPay, Maestro
- 🔢 **Formatting** — `format` groups digits per network (e.g. `XXXX XXXX XXXX XXXX`)
- 🙈 **Masking** — `mask` shows only the last four digits with a configurable mask character
- 📅 **Expiry validation** — `validateExpiry` accepts MM/YY and MM/YYYY and rejects past dates
- 🔐 **CVV validation** — `validateCVV` enforces the correct length per network (4 for Amex)
- 🧪 **Test numbers** — `generateTestNumber(for:)` returns documented Luhn-valid test cards
- 🔤 **String extensions** — `isValidCreditCard`, `creditCardType`, `formattedCreditCard`, `maskedCreditCard`, `creditCardInfo`, and more
- 📚 **Array extensions** — filter, group, and mask collections of card numbers
- 🧵 **Sendable models** — value types ready for concurrent use

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 16.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-credit-card-validator.git", from: "1.0.0")
]
```

## Usage

### Validation and Detection

```swift
import CreditCardValidator

let isValid = CreditCardValidator.validate("4532015112830366") // true
let type = CreditCardValidator.detectType("4532015112830366")  // .visa
```

### Formatting and Masking

```swift
import CreditCardValidator

let formatted = CreditCardValidator.format("4532015112830366", type: .visa)
// "4532 0151 1283 0366"

let masked = CreditCardValidator.mask("4532015112830366", type: .visa)
// "**** **** **** 0366"
```

### Expiry and CVV

```swift
import CreditCardValidator

let expiryOK = CreditCardValidator.validateExpiry("12/2030")        // true
let cvvOK = CreditCardValidator.validateCVV("1234", type: .amex)    // true (Amex requires 4)
```

### Test Numbers

```swift
import CreditCardValidator

let testVisa = CreditCardValidator.generateTestNumber(for: .visa)
// "4532015112830366" — for testing only
```

### String & Array Extensions

```swift
import CreditCardValidator

let valid = "4532 0151 1283 0366".isValidCreditCard       // true
let network = "4532015112830366".creditCardType           // .visa
let pretty = "4532015112830366".formattedCreditCard       // "4532 0151 1283 0366"
let hidden = "4532015112830366".maskedCreditCard          // "**** **** **** 0366"
let info = "4532015112830366".creditCardInfo              // CreditCardInfo?

let cards = ["4532015112830366", "5425233430109903", "invalid"]
let onlyValid = cards.validCreditCards
let grouped = cards.groupedByCardType
let maskedAll = cards.maskedCreditCards
```

## How It Works

`validate` strips non-digits, enforces a 12–19 digit range, detects the network from the prefix (including Mastercard's 2221–2720 2-series and extended Discover/Maestro ranges), checks that the length is valid for that network, and finally runs the Luhn checksum. Formatting and masking use each network's grouping pattern, and CVV/expiry validation apply network-specific and calendar-aware rules.

## Models

### `CreditCardInfo`

| Property | Type | Description |
|----------|------|-------------|
| `number` | `String` | Digits-only card number |
| `type` | `CardType` | Detected card network |
| `isValid` | `Bool` | Whether the number passes validation |
| `lastFourDigits` | `String` | Last four digits |
| `firstSixDigits` | `String` | First six digits (BIN) |
| `length` | `Int` | Number of digits |

`CardType` (`.visa`, `.mastercard`, `.amex`, `.discover`, `.dinersClub`, `.jcb`, `.unionPay`, `.maestro`) exposes `validLengths`, `cvvLength`, and `formatPattern`.

## Use Cases

- Checkout and payment form validation
- Card-on-file display with safe masking
- Network-aware formatting in UI
- Test-data generation for development

## Testing

```bash
swift test
```

The test suite covers Luhn validation, network detection across all eight card types, formatting, masking, expiry and CVV validation, the test-number generator, and the String/Array convenience extensions.

## License

MIT License — see LICENSE file for details.

## Author

Created by David Sherlock ([ArrayPress](https://github.com/arraypress)) in 2026.
