import SwiftUI

protocol ErrorServiceProtocol {
  var isShowingError: Bool { get }
  var currentError: String? { get }
  func showError(_ message: String)
  func hideError()
}

@Observable
final class ErrorService: ErrorServiceProtocol {
  var currentError: String?
  var isShowingError: Bool {
    currentError != nil
  }
  
  func showError(_ message: String) {
    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
      currentError = message
    }
    
    Task {
      try? await Task.sleep(for: .seconds(4))
      await MainActor.run {
        hideError()
      }
    }
  }
  
  func hideError() {
    withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
      currentError = nil
    }
  }
}
