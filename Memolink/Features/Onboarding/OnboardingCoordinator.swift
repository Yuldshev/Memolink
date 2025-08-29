import SwiftUI

@Observable
final class OnboardingCoordinator {
  var path = NavigationPath()
  let store = RegisterManager()
  let coordinator: AppCoordinator
  
  private let services: DIContainer
  var authService: AuthServiceProtocol { services.authService }
  var errorService: ErrorServiceProtocol { services.errorService }
  
  init(coordinator: AppCoordinator, services: DIContainer = .shared) {
    self.coordinator = coordinator
    self.services = services
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
  
  func showError(_ message: String) {
    errorService.showError(message)
  }
}
