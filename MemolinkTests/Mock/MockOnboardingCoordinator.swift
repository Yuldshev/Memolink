import Foundation
import SwiftUI
@testable import Memolink

final class MockOnboardingCoordinator {
  var lastErrorMessage: String?
  var lastSuccessMessage: String?
  var lastNavigationDestination: OnboardingCoordinator.Flow?
  var didNavigateToRoot = false
  var didCompleteLogin = false
  var didCompleteRegistration = false
  
  let store = MockRegisterStore()
  let authService = MockAuthService()
  let coordinator = MockAppCoordinator()
  
  func showError(_ message: LocalizedStringKey) {
    lastErrorMessage = String(describing: message)
  }
  
  func showSuccess(_ message: LocalizedStringKey) {
    lastSuccessMessage = String(describing: message)
  }
  
  func navigate(to destination: OnboardingCoordinator.Flow) {
    lastNavigationDestination = destination
  }
  
  func navigateToRoot() {
    didNavigateToRoot = true
  }
}

// MARK: - Mock Store
final class MockRegisterStore {
  var phone = ""
  var password = ""
  var isReset = false
  
  func reset() {
    phone = ""
    password = ""
    isReset = true
  }
}

// MARK: - Mock AuthService  
final class MockAuthService: AuthServiceProtocol {
  var isAuth = false
  
  var loginResult: Result<LoginData, Error>?
  var checkUserTypeResult: Result<UserTypeData, Error>?
  var verifyPhoneResult: Result<VerificationData, Error>?
  var registerResult: Result<RegisterData, Error>?

  func checkUserType(phone: String) async throws -> UserTypeData {
    guard let result = checkUserTypeResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func verifyPhone(phone: String, otp: String) async throws -> VerificationData {
    guard let result = verifyPhoneResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData {
    guard let result = registerResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func login(phone: String, password: String) async throws -> LoginData {
    guard let result = loginResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func loadCurrentUser() async {
    isAuth = true
  }
  
  func logout() {
    isAuth = false
  }
  
  func refreshTokenIfNeeded() async throws {
    // Mock implementation
  }
}

// MARK: - Mock App Coordinator
final class MockAppCoordinator {
  var didCompleteLogin = false
  var didCompleteRegistration = false
  
  func onboardingDidCompleteLogin() {
    didCompleteLogin = true
  }
  
  func onboardingDidCompleteRegistration() {
    didCompleteRegistration = true
  }
}