import Foundation

@Observable
final class AuthService {
  static let shared = AuthService()
  var currentUser: User?
  
  private init() {
    Task { await loadUser() }
  }
  
  private let cache = CacheService.shared
  
  func loadUser() async -> User? {
    return await cache.loadCache(key: "user_cache", as: User.self)
  }
  
  func login(user: User) {
    currentUser = user
    Task {
      await saveUser(user)
    }
  }
  
  func logout() {
    currentUser = nil
    Task {
      await cache.removeCache(for: "user_cache")
    }
  }
  
  private func saveUser(_ user: User) async {
    await cache.saveCache(user, key: "user_cache")
  }
}
