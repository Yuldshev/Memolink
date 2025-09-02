import SwiftUI

struct AppView: View {
  @State private var coordinator = AppCoordinator()
  
  var body: some View {
    Group {
      switch coordinator.appState {
      case .splash:
          SplashView()
            .transition(.blurReplace)
      case .onboarding:
          OnboardingFlow(coordinator: coordinator)
            .transition(.blurReplace)
      case .main:
          MainView(coordinator: coordinator)
            .transition(.blurReplace)
      }
    }
    .environment(\.locale, Locale(identifier: coordinator.locale.rawValue))
    .animation(.easeInOut(duration: 0.3), value: coordinator.appState)
  }
}

#Preview {
  AppView()
}
