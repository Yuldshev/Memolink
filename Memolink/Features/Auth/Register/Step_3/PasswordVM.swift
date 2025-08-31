import SwiftUI

@Observable
final class PasswordVM {
  var pass = ""
  var confirmPass = ""
  var isLoading = false
  
  // MARK: - Validation
  var isValid: Bool {
    pass == confirmPass && isValidPass
  }
  
  var isValidPass: Bool {
    return validation.hasLetters && validation.hasNumbers && validation.isLongEnough
  }
  
  var passwordStrength: PasswordStrength {
    guard !pass.isEmpty else {
      return PasswordStrength(progress: 0, color: .black200)
    }
    
    switch (validation.hasLetters, validation.hasNumbers, validation.isLongEnough) {
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
  
  private var validation: (hasLetters: Bool, hasNumbers: Bool, isLongEnough: Bool) {
    (
      hasLetters: pass.contains { $0.isLetter },
      hasNumbers: pass.contains { $0.isNumber },
      isLongEnough: pass.count > 6
    )
  }
  
  // MARK: - Router
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func next() {
    do {
      try validatePassword()
      router.store.password = pass
      router.navigate(to: .profile)
    } catch let error as RegisterError {
      router.showError(error.errorDescription)
    } catch {
      router.showError(RegisterError.unknown.errorDescription)
    }
  }
  
  private func validatePassword() throws {
    guard !pass.isEmpty else {
      throw RegisterError.passwordRequired
    }
    
    guard isValidPass else {
      throw RegisterError.weakPassword
    }
    
    guard pass == confirmPass else {
      throw RegisterError.passwordMismatch
    }
  }
}

// MARK: - Model Strength
struct PasswordStrength {
  let progress: Int
  let color: Color
}
