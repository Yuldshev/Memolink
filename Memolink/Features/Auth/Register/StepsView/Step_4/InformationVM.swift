import SwiftUI

@Observable
final class InformationVM {
  var avatar: UIImage?
  var firstName = ""
  var lastName = ""
  var email = ""
  var isLoading = false
  
  private let router: OnboardingCoordinator
  private let authService: AuthServiceProtocol
  
  init(router: OnboardingCoordinator) {
    self.router = router
    self.authService = router.authService
  }
  
  // MARK: - Router
  func complete() {
    print("complete method called")
    guard validateInformation() else { return }
    performRegistration()
  }
  
  private func performRegistration() {
    isLoading = true
    
    Task { @MainActor in
      do {
        let phone = router.store.phone
        let password = router.store.password
        
        let response = try await authService.register(
          phone: phone,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password
        )
        
        if response.status == "CREATED" {
          router.store.reset()
          router.showError(RegisterToast.userExists.description)
          router.navigateToRoot()
          router.coordinator.onboardingDidCompleteRegistration()
        }
      } catch {
        let registerError = mapError(error)
        router.showError(registerError.description)
      }
      isLoading = false
    }
  }
  
  private func validateInformation() -> Bool {
    guard !firstName.isEmpty else {
      router.showError(RegisterToast.firstNameRequired.description)
      return false
    }
    
    guard !lastName.isEmpty else {
      router.showError(RegisterToast.lastNameRequired.description)
      return false
    }
    
    guard !email.isEmpty else {
      router.showError(RegisterToast.emailRequired.description)
      return false
    }
    
    guard isValidEmail(email) else {
      router.showError(RegisterToast.invalidEmail.description)
      return false
    }
    return true
  }
  
  private func mapError(_ error: Error) -> RegisterToast {
    switch error {
    case URLError.notConnectedToInternet, URLError.timedOut:
      return .networkError
    default:
      return .serverError
    }
  }
  
  // MARK: - Valide
  var isValid: Bool {
    return !firstName.isEmpty && !lastName.isEmpty && isValidEmail(email)
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
}
