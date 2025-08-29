import SwiftUI

@Observable
final class AppCoordinator {
  var appState: AppState = .splash
  
  enum AppState {
    case splash, onboarding, main
  }
  
  private let authService = AuthService.shared
  
  init() { startAppFlow() }
  
  func onboardingDidCompleteRegistration() {
    appState = .onboarding
  }
  
  func onboardingDidCompleteLogin() {
    appState = .main
  }
  
  func userDidLogout() {
    authService.logout()
    appState = .onboarding
  }
  
  private func startAppFlow() {
    Task { @MainActor in
      try? await Task.sleep(for: .seconds(2))
      
      await authService.loadCurrentUser()
      
      if authService.currentUser == nil {
        appState = .onboarding
      } else {
        appState = .main
      }
    }
  }
}
