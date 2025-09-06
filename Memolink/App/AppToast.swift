import SwiftUI

enum AppToast {
  // Network Errors
  case noInternet
  case serverError
  case invalidCredentials
  
  // Validation
  case phoneRequired
  case invalidPhone
  case emailRequired
  case invalidEmail
  case passwordRequired
  case weakPassword
  case passwordMismatch
  case otpRequired
  case invalidOtp
  case firstNameRequired
  case lastNameRequired
  case firstNameTooShort
  case lastNameTooShort
  
  // Business Logic
  case userExists
  case loginSuccess
  case registerSuccess
  case otpSent
  
  var message: LocalizedStringKey {
    switch self {
    case .noInternet:
      return "Please check your internet connection"
    case .serverError:
      return "Server temporarily unavailable. Please try again later"
    case .invalidCredentials:
      return "Invalid phone number or password"
    case .phoneRequired:
      return "Phone number is required"
    case .invalidPhone:
      return "Please enter a valid phone number"
    case .emailRequired:
      return "Email is required"
    case .invalidEmail:
      return "Please enter a valid email"
    case .passwordRequired:
      return "Password is required"
    case .weakPassword:
      return "Password must contain at least 8 characters, uppercase, lowercase letters and number"
    case .passwordMismatch:
      return "Passwords do not match"
    case .otpRequired:
      return "SMS code is required"
    case .invalidOtp:
      return "SMS code must be 5 digits"
    case .firstNameRequired:
      return "First name is required"
    case .lastNameRequired:
      return "Last name is required"
    case .firstNameTooShort:
      return "First name must be at least 2 characters"
    case .lastNameTooShort:
      return "Last name must be at least 2 characters"
    case .userExists:
      return "User with this phone number already exists"
    case .loginSuccess:
      return "Login successful"
    case .registerSuccess:
      return "Registration successful. Please log in"
    case .otpSent:
      return "SMS code sent your phone number"
    }
  }
}
