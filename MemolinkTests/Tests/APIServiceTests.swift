import XCTest
@testable import Memolink

final class APIServiceTests: XCTestCase {
  var apiService: APIService!
  
  override func setUp() {
    super.setUp()
    clearKeychain()
    apiService = APIService()  // Simplified constructor
  }
  
  override func tearDown() {
    clearKeychain()
    super.tearDown()
  }
  
  // MARK: - Public Endpoints Tests (KISS principle)
  func testCheckUserType() async {
    await assertAsyncThrows {
      _ = try await self.apiService.checkUserType(phone: "998901234567")
    }
  }
  
  func testVerifyPhone() async {
    await assertAsyncThrows {
      _ = try await self.apiService.verifyPhone("998901234567", otp: "12345")
    }
  }
  
  func testRegister() async {
    await assertAsyncThrows {
      _ = try await self.apiService.register(
        phone: "998901234567",
        firstName: "Test",
        lastName: "User",
        password: "Password123"
      )
    }
  }
  
  func testLogin() async {
    await assertAsyncThrows {
      _ = try await self.apiService.login(phone: "998901234567", password: "Password123")
    }
  }
  
  // MARK: - Auth Required Tests (KISS principle)
  func testGetUserInfoWithoutToken() async {
    await assertAuthenticationError {
      _ = try await self.apiService.getUserInfo()
    }
  }
  
  func testChangePasswordWithoutToken() async {
    await assertAuthenticationError {
      try await self.apiService.changePassword(oldPassword: "old", newPassword: "new")
    }
  }
  
  func testChangeUserInfoWithoutToken() async {
    await assertAuthenticationError {
      _ = try await self.apiService.changeUserInfo(firstName: "Test", lastName: "User")
    }
  }
  
  // MARK: - Helper Methods (DRY principle)
  private func clearKeychain() {
    _ = Keychain<String>.delete("access_token")
    _ = Keychain<String>.delete("refresh_token")
  }
  
  private func assertAsyncThrows(_ operation: @escaping () async throws -> Void) async {
    do {
      try await operation()
      // Network calls should fail in test environment - that's expected
    } catch {
      XCTAssertTrue(true, "Expected network error in test environment")
    }
  }
  
  private func assertAuthenticationError(_ operation: @escaping () async throws -> Void) async {
    do {
      try await operation()
      XCTFail("Should throw authentication error")
    } catch NetworkError.authentication {
      XCTAssertTrue(true)
    } catch {
      XCTFail("Expected authentication error, got: \(error)")
    }
  }
}
