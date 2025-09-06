import SwiftUI

@Observable
final class OnboardingCoordinator {
  var path = NavigationPath()
  let store = RegisterStore()
  let coordinator: AppCoordinator
  
  private let services: DIContainer
  var authService: AuthServiceProtocol { services.authService }
  var toastService: ToastServiceProtocol { services.toastService }
  
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
  
  func showError(_ message: LocalizedStringKey) {
    toastService.showError(message)
  }
  
  func showSuccess(_ message: LocalizedStringKey) {
    toastService.showSuccess(message)
  }
}
