import SwiftUI

protocol PhoneFormatter: AnyObject {
  var rawPhone: String { get set }
  var displayPhone: String { get set }
}

extension PhoneFormatter {
  func updatePhone(_ input: String) {
    let digits = input.filter(\.isNumber)
    let limitedDigits = String(digits.prefix(12))
    
    rawPhone = limitedDigits
    displayPhone = limitedDigits.formatPhone()
  }
}

extension String {
  func formatPhone() -> String {
    let digits = self.filter(\.isNumber)
    
    guard digits.count >= 3, digits.hasPrefix("998") else {
      return "+998"
    }
    
    let phoneDigits = String(digits.dropFirst(3))
    var result = "+998"
    
    for (i, digit) in phoneDigits.enumerated() {
      switch i {
      case 0:
        result += " ("
        result.append(digit)
      case 2:
        result += ") "
        result.append(digit)
      case 5, 7:
        result += "-"
        result.append(digit)
      default:
        result.append(digit)
      }
    }
    return result
  }
}
