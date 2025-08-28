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
  
  private let authService: AuthService
  private weak var coordinator: AppCoordinator?
  
  init(authService: AuthService = .shared, coordinator: AppCoordinator) {
    self.authService = authService
    self.coordinator = coordinator
  }
  
  func login() {
    coordinator?.onboardingDidCompleteLogin()
  }
}
