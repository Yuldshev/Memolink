import SwiftUI

struct OnboardingFlow: View {
  @State private var router: OnboardingCoordinator
  
  init(coordinator: AppCoordinator) {
    self._router = State(wrappedValue: OnboardingCoordinator(coordinator: coordinator))
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      OnboardingView()
        .environment(router)
        .navigationDestination(for: OnboardingCoordinator.Flow.self) { flow in
          makeView(for: flow)
        }
    }
    .overlay(alignment: .top) {
      if router.toastService.isShowingToast {
        if let toast = router.toastService.currentToast {
          Toast(toastType: toast.type, message: toast.message) {
            router.toastService.hideToast()
          }
          .transition(
            .asymmetric(
              insertion: .move(edge: .top).combined(with: .opacity),
              removal: .move(edge: .top).combined(with: .opacity)
            ))
        }
      }
    }
    .animation(.spring(duration: 0.6, bounce: 0.3), value: router.toastService.isShowingToast)
  }
  
  @ViewBuilder
  private func makeView(for flow: OnboardingCoordinator.Flow) -> some View {
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
