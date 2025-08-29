import SwiftUI

@Observable
final class VerificationCodeVM {
  var code = ""
  var isLoading = false
  var isValid: Bool { code == "11111" }
  
  // MARK: - Timer
  var timeRemaining = 60
  private var timer: Timer?
  
  private let router: OnboardingRouter
  
  init(router: OnboardingRouter) {
    self.router = router
  }
  
  func next() {
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
