import SwiftUI

// MARK: - Error Handler
struct ErrorHandler {
  static func mapNetworkError(_ error: Error) -> AppToast {
    if let networkError = error as? NetworkError {
      switch networkError {
      case .noConnection:
        return .noInternet
      case .authentication:
        return .invalidCredentials
      case .server, .clientError:
        return .serverError
      }
    }
    return .serverError
  }
}
