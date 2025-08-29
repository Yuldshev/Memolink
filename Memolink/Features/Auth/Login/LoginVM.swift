import Foundation

@Observable
final class LoginVM: PhoneFormatter {
  var password = ""
  var isLoading = false
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  var errorMessage: String?
  
  var isValid: Bool {
    !rawPhone.isEmpty && !password.isEmpty
  }
  
  private let authService = AuthService.shared
  private let router: OnboardingRouter
  
  init(router: OnboardingRouter) {
    self.router = router
  }
  
  func login() {
    guard isValid else {
      errorMessage = "Please enter valid phone number and password"
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    Task { @MainActor in
      do {
        let user = try await performLogin()
        print("Login successful for: \(user.firstName) \(user.lastName)")
        
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteLogin()
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }
  
  private func performLogin() async throws -> User {
    return try await authService.login(phone: rawPhone, password: password)
  }
}
