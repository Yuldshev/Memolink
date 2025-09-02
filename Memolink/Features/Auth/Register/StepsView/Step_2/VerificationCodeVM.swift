import SwiftUI

@Observable
final class VerificationCodeVM {
  var code = ""
  var isLoading = false
  
  // MARK: - Timer
  var timeRemaining = 60
  private var timer: Timer?
  
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
    startTimer()
  }
  
  func next() {
    guard !code.isEmpty else {
      router.showError(RegisterToast.otpRequired.description)
      return
    }
    verifyPhone()
  }
  
  private func verifyPhone() {
    isLoading = true
    
    Task { @MainActor in
      do {
        let phone = router.store.phone
        let response = try await router.authService.verifyPhone(phone: phone, otp: code)
        if response.success {
          router.navigate(to: .password)
        }
      } catch {
        let registerError = mapError(error)
        router.showError(registerError.description)
      }
      isLoading = false
    }
  }
  
  private func mapError(_ error: Error) -> RegisterToast {
    switch error {
    case URLError.notConnectedToInternet, URLError.timedOut:
      return .networkError
    case URLError.userAuthenticationRequired:
      return .invalidOTP
    default:
      return .serverError
    }
  }
  
  // MARK: - Timer
  func startTimer() {
    guard timer == nil else { return }
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      guard let self else { return }
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        stopTimer()
      }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  func resetTimer() {
    stopTimer()
    code = ""
    timeRemaining = 60
    startTimer()
  }
  
  deinit {
    stopTimer()
  }
}
