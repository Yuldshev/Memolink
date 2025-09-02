import SwiftUI

@Observable
final class LoginVM: PhoneFormatter {
  var password = ""
  var isLoading = false
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  
  var isValid: Bool {
    !rawPhone.isEmpty && !password.isEmpty
  }
  
  private let authService: AuthServiceProtocol
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
    self.authService = router.authService
  }
  
  func login() {
    guard validateInput() else { return }
    performLogin()
  }
  
  private func performLogin() {
    isLoading = true
    
    Task { @MainActor in
      do {
        _ = try await router.authService.login(phone: rawPhone, password: password)
        router.showSuccess(LoginToast.loginSuccess.description)
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteLogin()
      } catch {
        router.showError(LocalizedStringKey(error.localizedDescription))
      }
      isLoading = false
    }
  }
  
  private func validateInput() -> Bool {
    guard rawPhone.count == 12 else {
      router.showError(LoginToast.invalidPhone.description)
      return false
    }
    
    guard !password.isEmpty else {
      router.showError(LoginToast.passwordRequired.description)
      return false
    }
    return true
  }
}
