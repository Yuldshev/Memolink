import SwiftUI

@Observable
final class PhoneNumberVM: PhoneFormatter {
  var isLoading = false
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  var isValid: Bool { rawPhone.count == 12 }
  
  private let router: OnboardingRouter
  
  init(router: OnboardingRouter) {
    self.router = router
  }
  
  func next() {
    guard isValid else {
      router.showError("Please enter a valid phone number")
      return
    }
    
    isLoading = true
    
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
