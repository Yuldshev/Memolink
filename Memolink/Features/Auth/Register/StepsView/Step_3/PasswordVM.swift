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
    
    let hasLetters = pass.contains { $0.isLetter }
    let hasNumbers = pass.contains { $0.isNumber }
    let isLongEnough = pass.count > 6
    
    switch (hasLetters, hasNumbers, isLongEnough) {
    case (false, false, _):
      return PasswordStrength(progress: 1, color: .red)
    case (true, false, _), (false, true, _):
      return PasswordStrength(progress: 2, color: .yellow)
    case (true, true, false):
      return PasswordStrength(progress: 2, color: .yellow)
    case (true, true, true):
      return PasswordStrength(progress: 3, color: .green)
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
