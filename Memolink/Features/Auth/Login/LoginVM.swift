import Foundation

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
    guard isValid else {
      router.showError("Please enter valid phone number and password")
      return
    }
    
    isLoading = true
    
    Task { @MainActor in
      do {
        let user = try await performLogin()
        print("Login successful for: \(user.firstName) \(user.lastName)")
        
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteLogin()
      } catch {
        router.showError(error.localizedDescription)
      }
      isLoading = false
    }
  }
  
  private func performLogin() async throws -> User {
    return try await authService.login(phone: rawPhone, password: password)
  }
}
