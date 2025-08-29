import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  lazy var authService: AuthServiceProtocol = AuthService.shared
  lazy var cacheService: CacheServiceProtocol = CacheService.shared
  lazy var errorService: ErrorServiceProtocol = ErrorService()
  
  private init() {}
}
