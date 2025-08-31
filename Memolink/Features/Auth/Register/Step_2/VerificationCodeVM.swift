import SwiftUI

@Observable
final class VerificationCodeVM {
  var code = ""
  var isLoading = false
  var isValid: Bool { code == "11111" }
  
  // MARK: - Timer
  var timeRemaining = 60
  private var timer: Timer?
  
  private let router: OnboardingCoordinator
  
  init(router: OnboardingCoordinator) {
    self.router = router
  }
  
  func next() {
    guard !code.isEmpty else {
      router.showError(RegisterError.otpRequired.errorDescription)
      return
    }
    
    guard isValid else {
      router.showError(RegisterError.otpInvalid.errorDescription)
      return
    }
    router.navigate(to: .password)
  }
  
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
