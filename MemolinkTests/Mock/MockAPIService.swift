import Foundation
import XCTest
@testable import Memolink

final class MockAPIService: APIServiceProtocol {
  var loginResult: Result<LoginData, Error>?
  var refreshResult: Result<TokenData, Error>?
  var checkUserTypeResult: Result<UserTypeData, Error>?
  var verifyPhoneResult: Result<VerificationData, Error>?
  var registerResult: Result<RegisterData, Error>?
  
  func login(phone: String, password: String) async throws -> LoginData {
    guard let result = loginResult else {
      throw URLError(.badServerResponse)
    }
    return try result.get()
  }
  
  func refresh(token: String) async throws -> TokenData {
    guard let result = refreshResult else {
      throw URLError(.badServerResponse)
    }
    return try result.get()
  }
  
  func checkUserType(phone: String) async throws -> UserTypeData {
    guard let result = checkUserTypeResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData {
    guard let result = verifyPhoneResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
  
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData {
    guard let result = registerResult else { throw URLError(.badServerResponse) }
    return try result.get()
  }
}
