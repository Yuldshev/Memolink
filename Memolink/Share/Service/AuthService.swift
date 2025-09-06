import Foundation

// MARK: - AuthServiceProtocol
protocol AuthServiceProtocol {
  var isAuth: Bool { get }
  func checkUserType(phone: String) async throws -> UserTypeData
  func verifyPhone(phone: String, otp: String) async throws -> VerificationData
  func register(phone: String, firstName: String, lastName: String, password: String) async throws -> UserData
  func login(phone: String, password: String) async throws -> TokenData
  func loadCurrentUser() async
  func logout()
  func refreshTokenIfNeeded() async throws
  func getUserInfo() async throws -> UserData
  func changePassword(oldPass: String, newPass: String) async throws
  func changeUserInfo(firstName: String, lastName: String) async throws -> UserData
}

// MARK: - AuthService
@Observable
final class AuthService: AuthServiceProtocol {
  var isAuth: Bool = false
 
  private let apiService: APIServiceProtocol
  
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
    password: String
  ) async throws -> UserData {
    try await apiService.register(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      password: password
    )
  }
  
  func login(phone: String, password: String) async throws -> TokenData {
    let tokenData = try await apiService.login(phone: phone, password: password)
    
    saveToken(tokenData)
    isAuth = true
    return tokenData
  }
  
  func loadCurrentUser() async {
    isAuth = Keychain<String>.get("refresh_token") != nil
  }
  
  func logout() {
    _ = Keychain<String>.delete("access_token")
    _ = Keychain<String>.delete("refresh_token")
    isAuth = false
  }
  
  func refreshTokenIfNeeded() async throws {
    guard let refreshToken = Keychain<String>.get("refresh_token") else {
      throw NetworkError.authentication
    }
    
    let tokenData = try await apiService.refresh(token: refreshToken)
    saveToken(tokenData)
  }
  
  func getUserInfo() async throws -> UserData {
    try await apiService.getUserInfo()
  }
  
  func changePassword(oldPass: String, newPass: String) async throws {
    try await apiService.changePassword(oldPassword: oldPass, newPassword: newPass)
  }
  
  func changeUserInfo(firstName: String, lastName: String) async throws -> UserData {
    try await apiService.changeUserInfo(firstName: firstName, lastName: lastName)
  }
  
  private func saveToken(_ tokenData: TokenData) {
    Keychain<String>.setSecureToken(tokenData.accessToken, key: "access_token")
    Keychain<String>.setSecureToken(tokenData.refreshToken, key: "refresh_token")
  }
}
