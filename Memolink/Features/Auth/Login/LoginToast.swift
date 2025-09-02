import SwiftUI

enum LoginToast: Error {
  // Errors
  case invalidPhone
  case passwordRequired
  case invalidCredentials
  
  // Network Errors
  case networkError
  case serverError
  case accountBlocked
  case sessionExpired
  
  // Success
  case loginSuccess
  
  var description: LocalizedStringKey {
    switch self {
    case .invalidPhone:
      return "Please enter a valid phone number"
    case .passwordRequired:
      return "Password is required"
    case .invalidCredentials:
      return "Invalid phone number or password"
    case .loginSuccess:
      return "Login successful"
    case .networkError:
      return "Please check your internet connection"
    case .serverError:
      return "Server temporarily unavailable. Try again later"
    case .accountBlocked:
      return "Account temporarily blocked"
    case .sessionExpired:
      return "Session expired. Please login again"
      
    }
  }
}
