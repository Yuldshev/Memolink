import SwiftUI

struct ToastMessage {
  let message: LocalizedStringKey
  let type: ToastType
}

protocol ToastServiceProtocol {
  var isShowingToast: Bool { get }
  var currentToast: ToastMessage? { get }
  func showToast(_ message: LocalizedStringKey, type: ToastType)
  func showError(_ message: LocalizedStringKey)
  func showSuccess(_ message: LocalizedStringKey)
  func showWarning(_ message: LocalizedStringKey)
  func showInfo(_ message: LocalizedStringKey)
  func hideToast()
}

@Observable
final class ToastService: ToastServiceProtocol {
  var currentToast: ToastMessage?
  var isShowingToast: Bool {
    currentToast != nil
  }
  
  func showToast(_ message: LocalizedStringKey, type: ToastType) {
    withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
      currentToast = ToastMessage(message: message, type: type)
    }
    
    let duration: TimeInterval = type == .error ? 4 : 3
    
    Task {
      try? await Task.sleep(for: .seconds(duration))
      await MainActor.run { hideToast() }
    }
  }
  
  func showError(_ message: LocalizedStringKey) {
    showToast(message, type: .error)
  }
  
  func showSuccess(_ message: LocalizedStringKey) {
    showToast(message, type: .success)
  }
  
  func showInfo(_ message: LocalizedStringKey) {
    showToast(message, type: .info)
  }
  
  func showWarning(_ message: LocalizedStringKey) {
    showToast(message, type: .warning)
  }
  
  func hideToast() {
    withAnimation(.spring(duration: 0.4, bounce: 0.1)) {
      currentToast = nil
    }
  }
}
