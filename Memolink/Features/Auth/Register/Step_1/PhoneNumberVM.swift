import SwiftUI

@Observable
final class PhoneNumberVM: PhoneFormatter {
  var isLoading = false
  var isValid: Bool { rawPhone.count == 12 }
  
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
}
