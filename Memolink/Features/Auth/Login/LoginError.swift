import SwiftUI

enum LoginError: Error, LocalizedError {
  case invalidPhone
  case passwordRequired
  case invalidPassword
  case userNotFound
  case unknown
  
  var errorDescription: LocalizedStringKey {
    switch self {
    case .invalidPhone:
      return "Please enter a valid phone number"
    case .passwordRequired:
      return "Password is required"
    case .invalidPassword:
      return "Invalid password"
    case .userNotFound:
      return "User not found"
    case .unknown:
      return "Unknown error"
    }
  }
}
