import SwiftUI

struct AppView: View {
  @State private var coordinator = AppCoordinator()
  
  var body: some View {
    Group {
      switch coordinator.appState {
      case .splash:
          SplashView()
      case .onboarding:
          OnboardingFlow(coordinator: coordinator)
      case .main:
          MainView(coordinator: coordinator)
      }
    }
    .environment(\.locale, Locale(identifier: coordinator.locale.rawValue))
    .animation(.easeInOut(duration: 0.3), value: coordinator.appState)
  }
}

#Preview {
  AppView()
}
