import SwiftUI

enum RegisterError: Error, LocalizedError {
  case invalidPhone
  case otpRequired
  case otpInvalid
  case firstNameRequired
  case lastNameRequired
  case emailRequired
  case invalidEmail
  case passwordRequired
  case weakPassword
  case passwordMismatch
  case incompleteData
  case unknown
  
  var errorDescription: LocalizedStringKey {
    switch self {
    case .invalidPhone:
      return "Please enter a valid phone number"
    case .otpRequired:
      return "SMS code is required"
    case .otpInvalid:
      return "Incorrect SMS code"
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
    case .incompleteData:
      return "Please fill all required fields"
    case .unknown:
      return "Unknown error"
    }
  }
}
