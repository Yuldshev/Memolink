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
    do {
      try validateInformation()
      performRegistration()
    } catch let error as RegisterError {
      router.showError(error.errorDescription)
    } catch {
      router.showError(RegisterError.unknown.errorDescription)
    }
  }
  
  private func performRegistration() {
    isLoading = true
    
    Task { @MainActor in
      do {
        router.store.firstName = firstName
        router.store.lastName = lastName
        router.store.email = email
        
        guard router.store.isDataComplete else {
          throw RegisterError.incompleteData
        }
        
        let user = router.store.createUser()
        await authService.register(user)
        
        router.store.reset()
        router.showSuccess("Registration completed successfully")
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteRegistration()
      } catch let error as RegisterError {
        router.showError(error.errorDescription)
      } catch {
        router.showError(RegisterError.unknown.errorDescription)
      }
      
      isLoading = false
    }
  }
  
  private func validateInformation() throws {
    guard !firstName.isEmpty else {
      throw RegisterError.firstNameRequired
    }
    
    guard !lastName.isEmpty else {
      throw RegisterError.lastNameRequired
    }
    
    guard !email.isEmpty else {
      throw RegisterError.emailRequired
    }
    
    guard isValidEmail(email) else {
      throw RegisterError.invalidEmail
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
