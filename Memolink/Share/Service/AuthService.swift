import Foundation

protocol AuthServiceProtocol {
  var isAuth: Bool { get }
  func checkUserType(phone: String) async throws -> UserTypeData
  func verifyPhone(phone: String, otp: String) async throws -> VerificationData
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData
  func login(phone: String, password: String) async throws -> LoginData
  func loadCurrentUser() async
  func logout()
  func refreshTokenIfNeeded() async throws
}

@Observable
final class AuthService: AuthServiceProtocol {
  var isAuth: Bool = false
 
  private let apiService: APIServiceProtocol
  private var tokenExpiryTime: Date?
  
  init(apiService: APIServiceProtocol) {
    self.apiService = apiService
  }
  
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
    
    saveTokens(loginData)
    isAuth = true
    return loginData
  }
  
  func loadCurrentUser() async {
    isAuth = Keychain<String>.get("refresh_token") != nil
    
    if isAuth {
      try? await refreshTokenIfNeeded()
    }
  }
  
  func logout() {
    _ = Keychain<String>.delete("access_token")
    _ = Keychain<String>.delete("refresh_token")
    tokenExpiryTime = nil
    isAuth = false
  }
  
  func refreshTokenIfNeeded() async throws {
    guard  let refreshToken: String = Keychain<String>.get("refresh_token") else {
      logout()
      throw URLError(.userAuthenticationRequired)
    }
    
    if let expiryTime = tokenExpiryTime, Date() < expiryTime.addingTimeInterval(-300) {
      return
    }
    
    do {
      let tokenData = try await apiService.refresh(token: refreshToken)
      saveTokens(tokenData)
    } catch {
      logout()
      throw URLError(.userAuthenticationRequired)
    }
  }
  
  private func saveTokens<T: Codable>(_ tokenData: T) where T: LoginDataProtocol {
    Keychain<String>.setSecureToken(tokenData.accessToken, key: "access_token")
    Keychain<String>.setSecureToken(tokenData.refreshToken, key: "refresh_token")
    
    tokenExpiryTime = Date().addingTimeInterval(TimeInterval(tokenData.expiresIn))
  }
}

// MARK: - Helper
protocol LoginDataProtocol {
  var accessToken: String { get }
  var refreshToken: String { get }
  var expiresIn: Int { get }
}

extension LoginData: LoginDataProtocol {}
extension TokenData: LoginDataProtocol {}
