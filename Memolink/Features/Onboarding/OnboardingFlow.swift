import SwiftUI

struct OnboardingFlow: View {
  @State private var router: OnboardingRouter
  
  init(coordinator: AppCoordinator) {
    self._router = State(wrappedValue: OnboardingRouter(coordinator: coordinator))
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      OnboardingView()
        .environment(router)
        .navigationDestination(for: OnboardingRouter.Flow.self) { flow in
          makeView(for: flow)
        }
    }
  }
  
  @ViewBuilder
  private func makeView(for flow: OnboardingRouter.Flow) -> some View {
    switch flow {
    case .login:
      LoginView(router: router)
    case .phoneNumber:
      PhoneNumberView(router: router)
    case .verificationCode:
      VerificationCodeView(router: router)
    case .password:
      PasswordView(router: router)
    case .profile:
      InformationView(router: router)
    }
  }
}

#Preview {
  OnboardingFlow(coordinator: AppCoordinator())
}
