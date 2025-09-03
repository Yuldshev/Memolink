import XCTest
@testable import Memolink

final class PasswordValidatorTests: XCTestCase {
  
  // MARK: - Valid Password Tests
  func testValidPassword() {
    XCTAssertTrue(PasswordValidator.validate("Password1"))
    XCTAssertTrue(PasswordValidator.validate("MyPass123"))
    XCTAssertTrue(PasswordValidator.validate("TestPassword9"))
  }
  
  // MARK: - Invalid Password Tests
  func testInvalidPasswordTooShort() {
    XCTAssertFalse(PasswordValidator.validate("Pass1"))
    XCTAssertFalse(PasswordValidator.validate("Ab1"))
    XCTAssertFalse(PasswordValidator.validate("1234567"))
  }
  
  func testInvalidPasswordMissingUppercase() {
    XCTAssertFalse(PasswordValidator.validate("password1"))
    XCTAssertFalse(PasswordValidator.validate("mypass123"))
  }
  
  func testInvalidPasswordMissingLowercase() {
    XCTAssertFalse(PasswordValidator.validate("PASSWORD1"))
    XCTAssertFalse(PasswordValidator.validate("MYPASS123"))
  }
  
  func testInvalidPasswordMissingNumber() {
    XCTAssertFalse(PasswordValidator.validate("Password"))
    XCTAssertFalse(PasswordValidator.validate("MyPassword"))
  }
  
  // MARK: - Edge Cases
  func testEmptyPassword() {
    XCTAssertFalse(PasswordValidator.validate(""))
    XCTAssertEqual(PasswordValidator.strength(""), 0)
  }
  
  func testPasswordWithSpecialCharacters() {
    XCTAssertTrue(PasswordValidator.validate("Password1!"))
    XCTAssertTrue(PasswordValidator.validate("Test@123"))
    XCTAssertTrue(PasswordValidator.validate("My#Pass1"))
  }
  
  func testPasswordWithSpaces() {
    XCTAssertTrue(PasswordValidator.validate("My Pass1"))
    XCTAssertTrue(PasswordValidator.validate(" Password1 "))
  }
  
  func testPasswordOnlyNumbers() {
    XCTAssertFalse(PasswordValidator.validate("12345678"))
  }
  
  func testPasswordOnlyLetters() {
    XCTAssertFalse(PasswordValidator.validate("Password"))
    XCTAssertFalse(PasswordValidator.validate("password"))
  }
  
  // MARK: - Strength Tests
  func testPasswordStrengthEmpty() {
    XCTAssertEqual(PasswordValidator.strength(""), 0)
  }
  
  func testPasswordStrengthWeak() {
    XCTAssertEqual(PasswordValidator.strength("pass"), 1)
    XCTAssertEqual(PasswordValidator.strength("1234"), 1)
    XCTAssertEqual(PasswordValidator.strength("PASS"), 1)
  }
  
  func testPasswordStrengthMedium() {
    XCTAssertEqual(PasswordValidator.strength("password"), 2)
    XCTAssertEqual(PasswordValidator.strength("PASSWORD"), 2)
    XCTAssertEqual(PasswordValidator.strength("Pass"), 2)
    XCTAssertEqual(PasswordValidator.strength("password12345678"), 3)
  }
  
  func testPasswordStrengthStrong() {
    XCTAssertEqual(PasswordValidator.strength("Password1"), 4)
    XCTAssertEqual(PasswordValidator.strength("MyTest123"), 4)
    XCTAssertEqual(PasswordValidator.strength("Pass12345678"), 4)
  }
  
  func testPasswordStrengthBorderCases() {
    XCTAssertEqual(PasswordValidator.strength("Pass1234"), 4)
    XCTAssertEqual(PasswordValidator.strength("Passwor1"), 4)
  }
}

