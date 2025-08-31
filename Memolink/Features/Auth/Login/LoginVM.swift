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
    do {
      try validateInput()
      performLogin()
    } catch let error as LoginError {
      router.showError(error.errorDescription)
    } catch {
      router.showError(LoginError.unknown.errorDescription)
    }
  }
  
  private func performLogin() {
    isLoading = true
    
    Task { @MainActor in
      do {
        let user = try await authService.login(phone: rawPhone, password: password)
        print("Login successful for: \(user.firstName) \(user.lastName)")
        
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteLogin()
      } catch AuthService.AuthError.userNotFound {
        router.showError(LoginError.userNotFound.errorDescription)
      } catch AuthService.AuthError.invalidPassword {
        router.showError(LoginError.invalidPassword.errorDescription)
      } catch {
        router.showError(LoginError.unknown.errorDescription)
      }
      isLoading = false
    }
  }
  
  private func validateInput() throws {
    guard rawPhone.count == 12 else {
      throw LoginError.invalidPhone
    }
    
    guard !password.isEmpty else {
      throw LoginError.passwordRequired
    }
  }
}
