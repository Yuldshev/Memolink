import SwiftUI

@Observable
final class InformationVM: BaseViewModel {
  var avatar: UIImage?
  var firstName = ""
  var lastName = ""
  
  override init(router: OnboardingCoordinator) {
    super.init(router: router)
  }
  
  // MARK: - Router
  func complete() {
    guard valid() else { return }
    performRegister()
  }
  
  private func performRegister() {
    startLoading()
    
    Task { @MainActor in
      do {
        let phone = router.store.phone
        let password = router.store.password
        let response = try await authService.register(
          phone: phone,
          firstName: firstName,
          lastName: lastName,
          password: password
        )
        
        if response.status == "CREATED" {
          router.store.reset()
          showSuccess(.registerSuccess)
          router.navigateToRoot()
        }
      } catch {
        handleError(error)
      }
      stopLoading()
    }
  }
  
  private func valid() -> Bool {
    validate(
      ValidationHelper.validateRegistration(
        firstName: firstName,
        lastName: lastName,
        password: router.store.password
      )
    )
  }
}
