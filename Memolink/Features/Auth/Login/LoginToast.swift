import SwiftUI

enum LoginToast: Error {
  // Errors
  case invalidPhone
  case passwordRequired
  case invalidCredentials
  
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
      
    }
  }
}
