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
      router.showError(RegisterToast.invalidPhone.description)
      return
    }
    checkUserType()
  }
  
  private func checkUserType() {
    isLoading = true
    
    Task { @MainActor in
      do {
        let response = try await router.authService.checkUserType(phone: rawPhone)
        
        if response.userType == "NEW_USER" {
          router.store.phone = rawPhone
          router.showSuccess(RegisterToast.otpSent.description)
          router.navigate(to: .verificationCode)
        } else {
          router.store.phone = rawPhone
          router.showError(RegisterToast.userExists.description)
          router.navigateToRoot()
        }
      } catch {
        let registerError = mapError(error)
        router.showError(registerError.description)
      }
      isLoading = false
    }
  }
  
  private func mapError(_ error: Error) -> RegisterToast {
    switch error {
    case URLError.notConnectedToInternet, URLError.timedOut:
      return .networkError
    default:
      return .serverError
    }
  }
}
