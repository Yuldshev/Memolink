import SwiftUI

@Observable
final class LoginVM: BaseViewModel, PhoneFormatter {
  var password = ""
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  
  override init(router: OnboardingCoordinator) {
    super.init(router: router)
    rawPhone = router.store.phone.isEmpty ? "998" : router.store.phone
  }
  
  func login() {
    guard validateInput() else { return }
    performLogin()
  }
  
  private func performLogin() {
    startLoading()
    
    Task { @MainActor in
      do {
        _ = try await authService.login(phone: rawPhone, password: password)
        showSuccess(.loginSuccess)
        router.navigateToRoot()
        router.coordinator.onboardingDidCompleteLogin()
      } catch {
        handleError(error)
      }
      stopLoading()
    }
  }
  
  private func validateInput() -> Bool {
    validate(ValidationHelper.validateLogin(phone: rawPhone, password: password))
  }
}
