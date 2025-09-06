import XCTest
@testable import Memolink

final class BaseViewModelTests: XCTestCase {
  
  // MARK: - Validation Result Tests (KISS principle)
  func testValidationResultSuccess() {
    let successResult = ValidationResult.success
    XCTAssertTrue(successResult.isValid)
    XCTAssertNil(successResult.toast)
  }
  
  func testValidationResultFailure() {
    let failureResult = ValidationResult.failure(.phoneRequired)
    XCTAssertFalse(failureResult.isValid)
    XCTAssertEqual(failureResult.toast, .phoneRequired)
  }
  
  // MARK: - Error Handler Tests (KISS principle)
  func testErrorHandlerNetworkErrors() {
    let noConnectionError = NetworkError.noConnection
    let authError = NetworkError.authentication
    let serverError = NetworkError.server
    
    let noConnectionToast = ErrorHandler.mapNetworkError(noConnectionError)
    let authToast = ErrorHandler.mapNetworkError(authError)
    let serverToast = ErrorHandler.mapNetworkError(serverError)
    
    XCTAssertEqual(noConnectionToast, .noInternet)
    XCTAssertEqual(authToast, .invalidCredentials)
    XCTAssertEqual(serverToast, .serverError)
  }
  
  func testErrorHandlerGenericError() {
    struct TestError: Error {}
    let genericError = TestError()
    
    let toast = ErrorHandler.mapNetworkError(genericError)
    
    XCTAssertEqual(toast, .serverError)
  }
  
  // MARK: - AppToast Message Tests (YAGNI - only testing key ones)
  func testAppToastMessages() {
    XCTAssertEqual(AppToast.loginSuccess.message, "Login successful")
    XCTAssertEqual(AppToast.phoneRequired.message, "Phone number is required")
    XCTAssertEqual(AppToast.passwordRequired.message, "Password is required")
    XCTAssertEqual(AppToast.userExists.message, "User with this phone number already exists")
  }
}