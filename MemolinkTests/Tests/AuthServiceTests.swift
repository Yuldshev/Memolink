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
  
  func testLoginSuccess() async throws {
    let mockLoginData = LoginData(
      accessToken: "access",
      expiresIn: 600,
      refreshExpiresIn: 0,
      refreshToken: "refresh",
      tokenType: "",
      sessionState: "",
      scope: ""
    )
    mockAPIService.loginResult = .success(mockLoginData)
    
    let _ = try await authService.login(phone: "998998882233", password: "Q12345678w")
    
    XCTAssertTrue(authService.isAuth)
    XCTAssertEqual(Keychain<String>.get("access_token"), "access")
    XCTAssertEqual(Keychain<String>.get("refresh_token"), "refresh")
  }
  
  func testLogoutClearsTokens() {
    Keychain<String>.setSecureToken("test_access", key: "access_token")
    Keychain<String>.setSecureToken("test_refresh", key: "refresh_token")
    authService.isAuth = true
    
    authService.logout()
    
    XCTAssertFalse(authService.isAuth)
    XCTAssertNil(Keychain<String>.get("access_token"))
    XCTAssertNil(Keychain<String>.get("refresh_token"))
  }
  
  func testRefreshTokenSuccess() async throws {
    Keychain<String>.setSecureToken("old_refresh", key: "refresh_token")
    let tokenData = TokenData(
      accessToken: "new_access",
      expiresIn: 600,
      refreshExpiresIn: 0,
      refreshToken: "new_refresh",
      tokenType: "",
      sessionState: "",
      scope: ""
    )
    
    mockAPIService.refreshResult = .success(tokenData)
    try await authService.refreshTokenIfNeeded()
    
    XCTAssertEqual(Keychain<String>.get("access_token"), "new_access")
    XCTAssertEqual(Keychain<String>.get("refresh_token"), "new_refresh")
  }
  
  func testRefreshTokenFailure() async {
    Keychain<String>.setSecureToken("refresh", key: "refresh_token")
    authService.isAuth = true
    mockAPIService.refreshResult = .failure(URLError(.badServerResponse))
    
    do {
      try await authService.refreshTokenIfNeeded()
      XCTFail("Should throw error")
    } catch {
      XCTAssertFalse(authService.isAuth)
      XCTAssertNil(Keychain<String>.get("refresh_token"))
    }
  }
  
  private func clearKeychain() {
    _ = Keychain<String>.delete("access_token")
    _ = Keychain<String>.delete("refresh_token")
  }
}

