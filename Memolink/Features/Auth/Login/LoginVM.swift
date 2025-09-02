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
        let loginError = mapError(error)
        router.showError(loginError.description)
      }
      isLoading = false
    }
  }
  
  private func validateInput() -> Bool {
    guard rawPhone.count == 12 else {
      router.showError(LoginToast.invalidPhone.description)
      return false
    }
    
    guard PasswordValidator.validate(password) else {
      router.showError(LoginToast.passwordRequired.description)
      return false
    }
    return true
  }
  
  private func mapError(_ error: Error) -> LoginToast {
    switch error {
    case URLError.notConnectedToInternet, URLError.timedOut:
      return .networkError
    case URLError.userAuthenticationRequired:
      return .invalidCredentials
    default:
      return .serverError
    }
  }
}
