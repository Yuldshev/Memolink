import SwiftUI

@Observable
final class OnboardingRouter {
  var path = NavigationPath()
  let store = RegisterManager()
  let authService = AuthService.shared
  let coordinator: AppCoordinator
  
  init(coordinator: AppCoordinator) {
    self.coordinator = coordinator
  }
  
  enum Flow: Hashable, Codable {
    case login, phoneNumber, verificationCode, password, profile
  }
  
  func navigate(to destination: Flow) {
    path.append(destination)
  }
  
  func navigateToRoot() {
    path = NavigationPath()
  }
}
