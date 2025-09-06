import SwiftUI

// MARK: - Base ViewModel
@Observable
class BaseViewModel {
  var isLoading = false
  
  let router: OnboardingCoordinator
  var authService: AuthServiceProtocol { router.authService }
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func startLoading() {
    isLoading = true
  }
  
  func stopLoading() {
    isLoading = false
  }
  
  func validate(_ result: ValidationResult) -> Bool {
    if let toast = result.toast {
      router.showError(toast.message)
      return false
    }
    return true
  }
  
  func handleError(_ error: Error) {
    let toast = ErrorHandler.mapNetworkError(error)
    router.showError(toast.message)
  }
  
  func showSuccess(_ toast: AppToast) {
    router.showSuccess(toast.message)
  }
}
