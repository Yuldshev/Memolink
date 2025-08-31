import SwiftUI

@Observable
final class PhoneNumberVM: PhoneFormatter {
  var isLoading = false
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  var isValid: Bool { rawPhone.count == 12 }
  
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func next() {
    guard isValid else {
      router.showError(RegisterError.invalidPhone.errorDescription)
      return
    }
    
    isLoading = true
    
    Task { @MainActor in
      router.store.phone = rawPhone
      router.navigate(to: .verificationCode)
      
      isLoading = false
    }
  }
}
