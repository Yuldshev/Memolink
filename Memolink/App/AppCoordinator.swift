import SwiftUI

@Observable
final class AppCoordinator: OnboardingRouterDelegate {
  var appState: AppState = .splash
  
  enum AppState {
    case splash, onboarding, main
  }
  
  private let authService = AuthService.shared
  
  init() { startAppFlow() }
  
  func userDidLogout() {
    appState = .onboarding
  }
  
  func onboardingDidCompleteRegistration() {
    appState = .onboarding
  }
  
  func onboardingDidCompleteLogin() {
    appState = .main
  }
  
  private func startAppFlow() {
    Task { @MainActor in
      try? await Task.sleep(for: .seconds(2))
      
      if authService.currentUser == nil {
        appState = .onboarding
      } else {
        appState = .main
      }
    }
  }
}
