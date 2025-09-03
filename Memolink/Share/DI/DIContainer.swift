import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  lazy var toastService: ToastServiceProtocol = ToastService()
  lazy var apiService: APIServiceProtocol = APIService()
  lazy var authService: AuthServiceProtocol = AuthService(apiService: apiService)
  
  private init() {}
}
