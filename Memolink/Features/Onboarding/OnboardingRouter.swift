import Foundation
import SwiftUI

// MARK: - Onboarding Router Delegate
protocol OnboardingRouterDelegate: AnyObject {
  func onboardingDidCompleteRegistration()
  func onboardingDidCompleteLogin()
}

// MARK: - Onboarding Router
@Observable
final class OnboardingRouter {
  var path = NavigationPath()
  weak var delegate: OnboardingRouterDelegate?
  private weak var coordinator: AppCoordinator?
  
  init(coordinator: AppCoordinator) {
    self.coordinator = coordinator
  }
  
  enum Flow: Hashable, Codable {
    case login, phoneNumber, verificationCode, password, profile
  }
  
  @ViewBuilder
  func makeView(for flow: Flow) -> some View {
    switch flow {
    case .login:
      if let coordinator = coordinator {
        LoginView(coordinator: coordinator)
      } else {
        Text("Error: Coordinator unavailable")
          .foregroundStyle(.red)
      }
    case .phoneNumber:
      PhoneNumberView()
    case .verificationCode:
      VerificationCodeView()
    case .password:
      PasswordView()
    case .profile:
      InformationView()
    }
  }
  
  func navigate(to destination: Flow) {
    path.append(destination)
  }
  
  func navigateToRoot() {
    path = NavigationPath()
  }
  
  func completeRegistation() {
    navigateToRoot()
    delegate?.onboardingDidCompleteRegistration()
  }
  
  func completeLogin() {
    delegate?.onboardingDidCompleteLogin()
  }
}
