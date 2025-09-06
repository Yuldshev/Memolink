import Foundation
@testable import Memolink

final class MockAPIService: APIServiceProtocol {
  // MARK: - Results Storage (DRY principle)
  var checkUserTypeResult: Result<UserTypeData, Error>?
  var verifyPhoneResult: Result<VerificationData, Error>?
  var registerResult: Result<UserData, Error>?
  var loginResult: Result<TokenData, Error>?
  var refreshResult: Result<TokenData, Error>?
  var getUserInfoResult: Result<UserData, Error>?
  var changePasswordResult: Result<Void, Error>?
  var changeUserInfoResult: Result<UserData, Error>?
  
  // MARK: - Helper Method (DRY principle)
  private func executeResult<T>(_ result: Result<T, Error>?) throws -> T {
    guard let result = result else {
      throw NetworkError.server
    }
    return try result.get()
  }
  
  // MARK: - APIServiceProtocol Implementation (KISS principle)
  func checkUserType(phone: String) async throws -> UserTypeData {
    try executeResult(checkUserTypeResult)
  }
  
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData {
    try executeResult(verifyPhoneResult)
  }
  
  func register(phone: String, firstName: String, lastName: String, password: String) async throws -> UserData {
    try executeResult(registerResult)
  }
  
  func login(phone: String, password: String) async throws -> TokenData {
    try executeResult(loginResult)
  }
  
  func refresh(token: String) async throws -> TokenData {
    try executeResult(refreshResult)
  }
  
  func getUserInfo() async throws -> UserData {
    try executeResult(getUserInfoResult)
  }
  
  func changePassword(oldPassword: String, newPassword: String) async throws {
    try executeResult(changePasswordResult)
  }
  
  func changeUserInfo(firstName: String, lastName: String) async throws -> UserData {
    try executeResult(changeUserInfoResult)
  }
}
