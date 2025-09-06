import Foundation
import SwiftUI

struct ValidationHelper {
  
  // Public Validators
  static func validatePhone(_ phone: String) -> ValidationResult {
    guard !phone.isEmpty else { return .failure(.phoneRequired) }
    return validateLength(phone, min: AppConstants.phoneLength, error: .invalidPhone)
  }
  
  static func validatePassword(_ password: String) -> ValidationResult {
    guard !password.isEmpty else { return .failure(.passwordRequired) }
    guard PasswordValidator.validate(password) else { return .failure(.weakPassword) }
    return .success
  }
  
  static func validatePasswordMatch(_ password: String, confirm: String) -> ValidationResult {
    password == confirm ? .success : .failure(.passwordMismatch)
  }
  
  static func validatePasswordStrength(_ password: String) -> PasswordStrengthResult {
    let strength = PasswordValidator.strength(password)
    
    switch strength {
    case 0...1:
      return PasswordStrengthResult(progress: 1, color: .red, isStrong: false)
    case 2...3:
      return PasswordStrengthResult(progress: 2, color: .yellow, isStrong: false)
    case 4:
      return PasswordStrengthResult(progress: 3, color: .green, isStrong: true)
    default:
      return PasswordStrengthResult(progress: 0, color: .gray, isStrong: false)
    }
  }
  
  static func validateOtp(_ otp: String) -> ValidationResult {
    guard !otp.isEmpty else { return .failure(.otpRequired) }
    return validateLength(otp, min: AppConstants.otpLength, error: .invalidOtp)
  }
  
  static func validateName(_ name: String, isFirstName: Bool) -> ValidationResult {
    let emptyError: AppToast = isFirstName ? .firstNameRequired : .lastNameRequired
    let shortError: AppToast = isFirstName ? .firstNameTooShort : .lastNameTooShort
    
    guard !name.isEmpty else { return .failure(emptyError) }
    return validateLength(name, min: 2, error: shortError)
  }
  
  // Core Validators
  private static func validateNotEmpty(_ value: String, error: AppToast) -> ValidationResult {
    value.isEmpty ? .failure(error) : .success
  }
  
  private static func validateLength(_ value: String, min: Int, error: AppToast) -> ValidationResult {
    value.count >= min ? .success : .failure(error)
  }
}

// MARK: - Validation Result
enum ValidationResult {
  case success
  case failure(AppToast)
  
  var isValid: Bool {
    if case .success = self { return true }
    return false
  }
  
  var toast: AppToast? {
    if case .failure(let toast) = self { return toast }
    return nil
  }
}

// MARK: - Password Strength Result
struct PasswordStrengthResult {
  let progress: Int
  let color: Color
  let isStrong: Bool
}

// MARK: - Validation Extensions
extension ValidationHelper {
  static func validateAll(_ validations: [ValidationResult]) -> ValidationResult {
    return validations.first { !$0.isValid } ?? .success
  }
  
  static func validateLogin(phone: String, password: String) -> ValidationResult {
    return validateAll([validatePhone(phone), validatePassword(password)])
  }
  
  static func validateRegistration(
    firstName: String,
    lastName: String,
    password: String
  ) -> ValidationResult {
    return validateAll([
      validateName(firstName, isFirstName: true),
      validateName(lastName, isFirstName: false),
      validatePassword(password)
    ])
  }
}
