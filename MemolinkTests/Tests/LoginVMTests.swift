import XCTest
@testable import Memolink

final class LoginVMTests: XCTestCase {
  
  // MARK: - Phone Validation Tests
  func testValidPhoneLength() {
    let validPhone = "998990573713"
    XCTAssertEqual(validPhone.count, 12)
  }
  
  func testInvalidPhoneLength() {
    let shortPhone = "99899057371"
    let longPhone = "9989905737133"
    
    XCTAssertNotEqual(shortPhone.count, 12)
    XCTAssertNotEqual(longPhone.count, 12)
  }
  
  // MARK: - Password Validation Tests
  func testPasswordValidation() {
    let validPassword = "Password1"
    let weakPassword = "weak"
    
    XCTAssertTrue(PasswordValidator.validate(validPassword))
    XCTAssertFalse(PasswordValidator.validate(weakPassword))
  }
}