import SwiftUI

@Observable
final class PhoneNumberVM: PhoneFormatter {
  var isLoading = false
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  var errorMessage: String?
  var isValid: Bool { rawPhone.count == 12 }
  
  private let router: OnboardingRouter
  
  init(router: OnboardingRouter) {
    self.router = router
  }
  
  func next() {
    guard isValid else {
      errorMessage = "Please enter a valid phone number"
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    Task { @MainActor in
      await checkPhoneAPI()
      router.store.phone = rawPhone
      router.navigate(to: .verificationCode)
      
      isLoading = false
    }
  }
  
  private func checkPhoneAPI() async {
    try? await Task.sleep(for: .seconds(0.3))
  }
}
