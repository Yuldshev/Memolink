import XCTest
@testable import Memolink

final class AuthServiceTests: XCTestCase {
  var authService: AuthService!
  var mockAPIService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    clearKeychain()
    mockAPIService = MockAPIService()
    authService = AuthService(apiService: mockAPIService)
  }
  
  override func tearDown() {
    clearKeychain()
    super.tearDown()
  }
  
  // MARK: - Login Tests (KISS principle)
  func testLoginSuccess() async throws {
    let tokenData = createTokenData(access: "access", refresh: "refresh")
    mockAPIService.loginResult = .success(tokenData)
    
    _ = try await authService.login(phone: "998901234567", password: "Password123")
    
    XCTAssertTrue(authService.isAuth)
    XCTAssertEqual(Keychain<String>.get("access_token"), "access")
    XCTAssertEqual(Keychain<String>.get("refresh_token"), "refresh")
  }
  
  func testLoginFailure() async {
    mockAPIService.loginResult = .failure(NetworkError.authentication)
    
    await assertThrowsError(NetworkError.authentication) {
      _ = try await self.authService.login(phone: "998901234567", password: "wrong")
    }
    
    XCTAssertFalse(authService.isAuth)
  }
  
  // MARK: - Logout Tests (KISS principle)
  func testLogoutClearsTokens() {
    setupTokens(access: "test_access", refresh: "test_refresh")
    authService.isAuth = true
    
    authService.logout()
    
    XCTAssertFalse(authService.isAuth)
    XCTAssertNil(Keychain<String>.get("access_token"))
    XCTAssertNil(Keychain<String>.get("refresh_token"))
  }
  
  // MARK: - Refresh Token Tests (KISS principle)  
  func testRefreshTokenSuccess() async throws {
    Keychain<String>.setSecureToken("old_refresh", key: "refresh_token")
    let tokenData = createTokenData(access: "new_access", refresh: "new_refresh")
    mockAPIService.refreshResult = .success(tokenData)
    
    try await authService.refreshTokenIfNeeded()
    
    XCTAssertEqual(Keychain<String>.get("access_token"), "new_access")
    XCTAssertEqual(Keychain<String>.get("refresh_token"), "new_refresh")
  }
  
  func testRefreshTokenWithoutRefreshToken() async {
    await assertThrowsError(NetworkError.authentication) {
      try await self.authService.refreshTokenIfNeeded()
    }
  }
  
  // MARK: - User Operations Tests (KISS principle)
  func testCheckUserType() async throws {
    let userTypeData = UserTypeData(userType: "NEW_USER")
    mockAPIService.checkUserTypeResult = .success(userTypeData)
    
    let result = try await authService.checkUserType(phone: "998901234567")
    
    XCTAssertEqual(result.userType, "NEW_USER")
  }
  
  func testVerifyPhone() async throws {
    let verificationData = VerificationData(success: true, message: "Success")
    mockAPIService.verifyPhoneResult = .success(verificationData)
    
    let result = try await authService.verifyPhone(phone: "998901234567", otp: "12345")
    
    XCTAssertTrue(result.success)
  }
  
  func testRegister() async throws {
    let userData = createUserData()
    mockAPIService.registerResult = .success(userData)
    
    let result = try await authService.register(
      phone: "998901234567",
      firstName: "John",
      lastName: "Doe",
      password: "Password123"
    )
    
    XCTAssertEqual(result.firstName, "John")
    XCTAssertEqual(result.lastName, "Doe")
  }
  
  // MARK: - Helper Methods (DRY principle)
  private func clearKeychain() {
    _ = Keychain<String>.delete("access_token")
    _ = Keychain<String>.delete("refresh_token")
  }
  
  private func setupTokens(access: String, refresh: String) {
    Keychain<String>.setSecureToken(access, key: "access_token")
    Keychain<String>.setSecureToken(refresh, key: "refresh_token")
  }
  
  private func createTokenData(access: String, refresh: String) -> TokenData {
    TokenData(accessToken: access, expiresIn: 600, refreshToken: refresh)
  }
  
  private func createUserData() -> UserData {
    UserData(
      phoneNumber: "998901234567",
      email: "test@example.com",
      firstName: "John",
      lastName: "Doe",
      userId: "123",
      status: "CREATED"
    )
  }
  
  private func assertThrowsError<T: Equatable>(_ expectedError: T, _ operation: @escaping () async throws -> Void) async where T: Error {
    do {
      try await operation()
      XCTFail("Should throw error")
    } catch let error as T where error == expectedError {
      XCTAssertTrue(true)
    } catch {
      XCTFail("Expected \(expectedError), got \(error)")
    }
  }
}

