import SwiftUI

@Observable
final class PhoneNumberVM: BaseViewModel, PhoneFormatter {
  var rawPhone: String = "998"
  var displayPhone: String = "+998"
  
  override init(router: OnboardingCoordinator) {
    super.init(router: router)
  }
  
  func next() {
    guard validate(ValidationHelper.validatePhone(rawPhone)) else { return }
    checkUserType()
  }
  
  private func checkUserType() {
    startLoading()
    
    Task { @MainActor in
      do {
        let response = try await authService.checkUserType(phone: rawPhone)
        if response.userType == "NEW_USER" {
          router.store.phone = rawPhone
          showSuccess(.otpSent)
          router.navigate(to: .verificationCode)
        } else {
          router.store.phone = rawPhone
          router.showError(AppToast.userExists.message)
          router.navigateToRoot()
        }
      } catch {
        handleError(error)
      }
      stopLoading()
    }
  }
}
