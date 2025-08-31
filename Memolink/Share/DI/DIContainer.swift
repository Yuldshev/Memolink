import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  lazy var authService: AuthServiceProtocol = AuthService.shared
  lazy var cacheService: CacheServiceProtocol = CacheService.shared
  lazy var toastService: ToastServiceProtocol = ToastService()
  
  private init() {}
}
