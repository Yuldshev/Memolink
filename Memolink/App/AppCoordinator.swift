import SwiftUI

@Observable
final class AppCoordinator {
  var appState: AppState = .splash
  var locale: LocaleApp = .en
  
  enum AppState {
    case splash, onboarding, main
  }
  
  private let authService: AuthServiceProtocol
  
  init() {
    self.authService = DIContainer.shared.authService
    loadSavedLocale()
    startAppFlow()
  }
  
  // MARK: - Change Locale
  func changeLocale(_ newLocale: LocaleApp) {
    locale = newLocale
    saveLocale()
  }
  
  private func loadSavedLocale() {
    let saveLocale = UserDefaults.standard.string(forKey: "app_locale") ?? "en"
    locale = LocaleApp(rawValue: saveLocale) ?? .en
  }
  
  private func saveLocale() {
    UserDefaults.standard.set(locale.rawValue, forKey: "app_locale")
  }
  
  // MARK: - Navigation State
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
      
      if authService.isAuth {
        appState = .main
      } else {
        appState = .onboarding
      }
    }
  }
}
