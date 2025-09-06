import SwiftUI

@Observable
final class PasswordVM: BaseViewModel {
  var pass = ""
  var confirmPass = ""
  
  var passwordStrength: PasswordStrength {
    let result = ValidationHelper.validatePasswordStrength(pass)
    return PasswordStrength(progress: result.progress, color: result.color)
  }
  
  override init(router: OnboardingCoordinator) {
    super.init(router: router)
  }
  
  func next() {
    guard validatePassword() else { return }
    router.store.password = pass
    router.navigate(to: .profile)
  }
 
  private func validatePassword() -> Bool {
    return validate(ValidationHelper.validateAll([
      ValidationHelper.validatePassword(pass),
      ValidationHelper.validatePasswordMatch(pass, confirm: confirmPass)
    ]))
  }
}

// MARK: - Model Strength
struct PasswordStrength {
  let progress: Int
  let color: Color
}
