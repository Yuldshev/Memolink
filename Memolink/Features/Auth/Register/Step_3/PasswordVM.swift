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
      isLongEnough: pass.count > 8
    )
  }
  
  // MARK: - Error message
  var errorMessage: String? {
    guard !pass.isEmpty else {
      return "Password must contain letters, numbers and be longer than 8 characters"
    }
    
    var errors: [String] = []
    
    if !validation.hasLetters { errors.append("letters") }
    if !validation.hasNumbers { errors.append("numbers") }
    if !validation.isLongEnough { errors.append("more than 8 characters") }
    
    if !errors.isEmpty {
      return "Password must contain " + errors.joined(separator: ", ")
    }
    if !confirmPass.isEmpty && pass != confirmPass {
      return "Passwords do not match"
    }
    
    return nil
  }
  
  // MARK: - Router
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func next() {
    guard isValid else { return }
    
    isLoading = true
    
    Task { @MainActor in
      if await checkPasswordAPI() {
        router.store.password = pass
        router.navigate(to: .profile)
      }
      isLoading = false
    }
  }
  
  private func checkPasswordAPI() async -> Bool {
    return isValidPass
  }
}

// MARK: - Model Strength
struct PasswordStrength {
  let progress: Int
  let color: Color
}
