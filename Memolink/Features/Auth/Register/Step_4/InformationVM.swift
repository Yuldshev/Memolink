import SwiftUI

@Observable
final class InformationVM {
  var avatar: UIImage?
  var firstName = ""
  var lastName = ""
  var email = ""
  var isLoading = false
  
  // MARK: - Valide
  var isValid: Bool {
    return !firstName.isEmpty && !lastName.isEmpty && isValidEmail(email)
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
  
  // MARK: - Router
  private let router: OnboardingRouter
  
  init(router: OnboardingRouter) {
    self.router = router
  }
  
  func complete() {
    guard isValid else {
      router.showError("Please fill all fields correctly")
      return
    }
    
    isLoading = true
    
    Task { @MainActor in
      do {
        router.store.firstName = firstName
        router.store.lastName = lastName
        router.store.email = email
        router.store.avatar = avatar?.pngData()
        
        try await performRegistration()
        
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteRegistration()
      } catch {
        router.showError(error.localizedDescription)
      }
      isLoading = false
    }
    
  }
  
  private func performRegistration() async throws {
    guard router.store.isDataComplete else {
      throw RegisterError.incompleteData
    }
    
    let user = router.store.createUser()
    await router.authService.register(user)
    router.store.reset()
  }
}
