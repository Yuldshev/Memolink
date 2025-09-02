import SwiftUI

@Observable
final class PasswordVM {
  var pass = ""
  var confirmPass = ""
  var isLoading = false
  
  // MARK: - Validation
  var passwordStrength: PasswordStrength {
    guard !pass.isEmpty else {
      return PasswordStrength(progress: 0, color: .black200)
    }
    
    let strength = PasswordValidator.strength(pass)
    
    switch strength {
    case 0...1:
      return PasswordStrength(progress: 1, color: .red)
    case 2...3:
      return PasswordStrength(progress: 2, color: .yellow)
    case 4:
      return PasswordStrength(progress: 3, color: .green)
    default:
      return PasswordStrength(progress: 0, color: .black200)
    }
  }
  
  // MARK: - Router
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func next() {
    guard validatePassword() else { return }
    router.store.password = pass
    router.navigate(to: .profile)
  }
 
  private func validatePassword() -> Bool {
    guard !pass.isEmpty else {
      router.showError(RegisterToast.passwordRequired.description)
      return false
    }
    
    guard passwordStrength.progress == 3 else {
      router.showError(RegisterToast.weakPassword.description)
      return false
    }
    
    guard pass == confirmPass else {
      router.showError(RegisterToast.passwordMismatch.description)
      return false
    }
    return true
  }
}

// MARK: - Model Strength
struct PasswordStrength {
  let progress: Int
  let color: Color
}
