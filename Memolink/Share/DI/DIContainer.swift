import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  lazy var authService: AuthServiceProtocol = AuthService.shared
  lazy var toastService: ToastServiceProtocol = ToastService()
  lazy var apiService = APIService()
  
  private init() {}
}
