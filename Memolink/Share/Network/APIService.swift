import SwiftUI
import Alamofire
import Network

// MARK: - API Service Protocol
protocol APIServiceProtocol {
  func checkUserType(phone: String) async throws -> UserTypeData
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData
  func register(phone: String, firstName: String, lastName: String, password: String) async throws -> UserData
  func login(phone: String, password: String) async throws -> TokenData
  func refresh(token: String) async throws -> TokenData
  func getUserInfo() async throws -> UserData
  func changePassword(oldPassword: String, newPassword: String) async throws
  func changeUserInfo(firstName: String, lastName: String) async throws -> UserData
}

// MARK: - API Service Implementation
final class APIService: APIServiceProtocol {
  private let apiClient = APIClient()
  
  // Public Endpoints (no auth)
  func checkUserType(phone: String) async throws -> UserTypeData {
    try await apiClient.request(
      "/api/auth/user-type-check",
      method: .post,
      parameters: ["phoneNumber": phone]
    )
  }
  
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData {
    try await apiClient.request(
      "/api/auth/verify-phone-number",
      method: .post,
      parameters: ["phoneNumber": phone, "otp": otp]
    )
  }
  
  func register(phone: String, firstName: String, lastName: String, password: String) async throws -> UserData {
    try await apiClient.request(
      "/api/auth/register",
      method: .post,
      parameters: [
        "phoneNumber": phone,
        "firstName": firstName,
        "lastName": lastName,
        "password": password
      ]
    )
  }
  
  func login(phone: String, password: String) async throws -> TokenData {
    try await apiClient.request(
      "/api/auth/login",
      method: .post,
      parameters: ["phoneNumber": phone, "password": password]
    )
  }
  
  func refresh(token: String) async throws -> TokenData {
    try await apiClient.request(
      "api/auth/refresh",
      method: .post,
      parameters: ["refreshToken": token]
    )
  }
  
  // Auth Endpoints
  func getUserInfo() async throws -> UserData {
    guard let token = getToken() else {
      throw NetworkError.authentication
    }
    
    return try await apiClient.request("/api/user/me", method: .get, token: token)
  }
  
  func changePassword(oldPassword: String, newPassword: String) async throws {
    guard let token = getToken() else {
      throw NetworkError.authentication
    }
    
    let _: EmptyResponse = try await apiClient.request(
      "/api/user/change-password",
      method: .post,
      parameters: ["oldPassword": oldPassword, "newPassword": newPassword],
      token: token
    )
  }
  
  func changeUserInfo(firstName: String, lastName: String) async throws -> UserData {
    guard let token = getToken() else {
      throw NetworkError.authentication
    }
    
    return try await apiClient.request(
      "/api/user/change-info",
      method: .post,
      parameters: ["firstName": firstName, "lastName": lastName],
      token: token
    )
  }
  
  // Private Method
  private func getToken() -> String? {
    return Keychain<String>.get("access_token")
  }
}

// MARK: - Empty Response for void endpoints
private struct EmptyResponse: Codable {}
