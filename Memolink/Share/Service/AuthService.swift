import Foundation

protocol AuthServiceProtocol {
  var isAuth: Bool { get }
  func checkUserType(phone: String) async throws -> UserTypeData
  func verifyPhone(phone: String, otp: String) async throws -> VerificationData
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData
  func login(phone: String, password: String) async throws -> LoginData
  func loadCurrentUser() async
  func logout()
}

@Observable
final class AuthService: AuthServiceProtocol {
  static let shared = AuthService()
  var isAuth: Bool = false
    
  private let cache = CacheService.shared
  private let apiService = APIService()
  
  private init() {}
  
  func checkUserType(phone: String) async throws -> UserTypeData {
    try await apiService.checkUserType(phone: phone)
  }
  
  func verifyPhone(phone: String, otp: String) async throws -> VerificationData {
    try await apiService.verifyPhone(phone, otp: otp)
  }
  
  func register(
    phone: String,
    firstName: String,
    lastName: String,
    email: String,
    password: String
  ) async throws -> RegisterData {
    try await apiService.register(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password
    )
  }
  
  func login(phone: String, password: String) async throws -> LoginData {
    let loginData = try await apiService.login(phone: phone, password: password)
    
    await cache.saveCache(loginData.accessToken, key: "access_token")
    await cache.saveCache(loginData.refreshToken, key: "refresh_token")
    
    isAuth = true
    return loginData
  }
  
  func loadCurrentUser() async {
    isAuth = await cache.loadCache(key: "access_token", as: String.self) != nil
  }
  
  func logout() {
    isAuth = false
    Task {
      await cache.removeCache(for: "access_token")
      await cache.removeCache(for: "refresh_token")
    }
  }
}
