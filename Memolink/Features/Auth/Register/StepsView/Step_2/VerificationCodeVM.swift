import SwiftUI

@Observable
final class VerificationCodeVM: BaseViewModel {
  var code = ""
  
  // MARK: - Timer
  var timeRemaining = AppConstants.timerDuration
  private var timer: Timer?
  
  override init(router: OnboardingCoordinator) {
    super.init(router: router)
    startTimer()
  }
  
  func next() {
    guard validate(ValidationHelper.validateOtp(code)) else { return }
    verifyPhone()
  }
  
  private func verifyPhone() {
    startLoading()
    
    Task { @MainActor in
      do {
        let phone = router.store.phone
        let response = try await authService.verifyPhone(phone: phone, otp: code)
        
        if response.success {
          router.navigate(to: .password)
        }
      } catch {
        handleError(error)
      }
      stopLoading()
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
    timeRemaining = AppConstants.timerDuration
    startTimer()
  }
  
  deinit {
    stopTimer()
  }
}
