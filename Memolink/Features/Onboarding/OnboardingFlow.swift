import SwiftUI

struct OnboardingFlow: View {
  @Environment(AppCoordinator.self) private var coordinator
  @State private var router: OnboardingRouter
  
  init(coordinator: AppCoordinator) {
    self._router = State(wrappedValue: OnboardingRouter(coordinator: coordinator))
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      OnboardingView()
        .environment(router)
        .navigationDestination(for: OnboardingRouter.Flow.self) { flow in
          router.makeView(for: flow)
            .environment(coordinator)
            .environment(router)
        }
    }
    .environment(router)
    .onAppear { router.delegate = coordinator }
  }
}

#Preview {
  OnboardingFlow(coordinator: AppCoordinator())
}
