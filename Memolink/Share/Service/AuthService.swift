import Foundation
import SwiftUI

protocol AuthServiceProtocol {
  var currentUser: User? { get }
  func login(phone: String, password: String) async throws -> User
  func register(_ user: User) async
  func logout()
  func loadCurrentUser() async
}

@Observable
final class AuthService: AuthServiceProtocol {
  static let shared = AuthService()
  var currentUser: User?
  
  private init() {}
  
  private let cache = CacheService.shared
  
  func register(_ user: User) async {
    await cache.saveCache(user, key: "user_cache")
  }
  
  func loadCurrentUser() async {
    currentUser = await cache.loadCache(key: "user_cache", as: User.self)
  }
  
  func login(phone: String, password: String) async throws -> User {
    guard let cachedUser = await cache.loadCache(key: "user_cache", as: User.self) else {
      throw AuthError.userNotFound
    }
    
    guard cachedUser.phone == phone else {
      throw AuthError.userNotFound
    }
    
    guard cachedUser.password == password else {
      throw AuthError.invalidPassword
    }
    
    currentUser = cachedUser
    return cachedUser
  }
  
  func logout() {
    currentUser = nil
    Task {
      await cache.removeCache(for: "user_cache")
    }
  }
  
  enum AuthError: Error, LocalizedError {
    case userNotFound
    case invalidPassword
    
    var errorDescription: LocalizedStringKey {
      switch self {
      case .userNotFound:
        return "User not found"
      case .invalidPassword:
        return "Invalid password"
      }
    }
  }
}
