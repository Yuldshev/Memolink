import SwiftUI

enum RegisterToast {
  // Errors
  case invalidPhone
  case otpRequired
  case userExists
  case firstNameRequired
  case lastNameRequired
  case emailRequired
  case invalidEmail
  case passwordRequired
  case weakPassword
  case passwordMismatch
  
  // Success
  case otpSent
  case registerComplete
  
  var description: LocalizedStringKey {
    switch self {
    case .invalidPhone:
      return "Please enter a valid phone number"
    case .otpRequired:
      return "SMS code is required"
    case .userExists:
      return "User with this phone number already exists"
    case .firstNameRequired:
      return "First name is required"
    case .lastNameRequired:
      return "Last name is required"
    case .emailRequired:
      return "Email is required"
    case .invalidEmail:
      return "Please enter a valid email"
    case .passwordRequired:
      return "Password is required"
    case .weakPassword:
      return "Password must be at least 6 characters"
    case .passwordMismatch:
      return "Passwords do not match"
    case .otpSent:
      return "SMS code sent to your phone number"
    case .registerComplete:
      return "Registration successful. Please log in"
      
    }
  }
}
