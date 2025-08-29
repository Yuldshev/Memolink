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
    .overlay(alignment: .top) {
      if router.errorService.isShowingError {
        ErrorToast(message: router.errorService.currentError ?? "") {
          router.errorService.hideError()
        }
        .transition(
          .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
          ))
      }
    }
    .animation(.spring(duration: 0.6, bounce: 0.3), value: router.errorService.isShowingError)
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
