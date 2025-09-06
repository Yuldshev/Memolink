import XCTest
@testable import Memolink

// MARK: - Validation Only Tests (KISS principle - без сложных dependencies)
final class ViewModelTests: XCTestCase {
  
  // MARK: - Password Strength Tests (тестируем только логику)
  func testPasswordStrengthCalculation() {
    // Тест слабого пароля (только lowercase)
    let weakStrength = PasswordValidator.strength("weak")
    XCTAssertEqual(weakStrength, 1)
    
    // Тест среднего пароля (длина + lowercase + uppercase)
    let mediumStrength = PasswordValidator.strength("Password")
    XCTAssertEqual(mediumStrength, 3)
    
    // Тест сильного пароля (все 4 проверки)
    let strongStrength = PasswordValidator.strength("Password1")
    XCTAssertEqual(strongStrength, 4)
  }
  
  // MARK: - Password Validation Tests
  func testPasswordValidation() {
    XCTAssertTrue(PasswordValidator.validate("Password1"))
    XCTAssertFalse(PasswordValidator.validate("weak"))
    XCTAssertFalse(PasswordValidator.validate(""))
  }
  
  // MARK: - Phone Validation Tests
  func testPhoneValidation() {
    // Valid phones
    XCTAssertTrue(ValidationHelper.validatePhone("998990573713").isValid)
    XCTAssertTrue(ValidationHelper.validatePhone("998901234567").isValid)
    
    // Invalid phones  
    XCTAssertFalse(ValidationHelper.validatePhone("123").isValid)
    XCTAssertFalse(ValidationHelper.validatePhone("").isValid)
    XCTAssertFalse(ValidationHelper.validatePhone("99899057371").isValid) // Too short
  }
  
  // MARK: - Email Validation Tests  
  func testEmailValidation() {
    let validEmails = ["test@example.com", "user@domain.co.uk"]
    let invalidEmails = ["invalid", "@domain.com", "user@"]
    
    for email in validEmails {
      XCTAssertTrue(isValidEmail(email), "Should be valid: \(email)")
    }
    
    for email in invalidEmails {
      XCTAssertFalse(isValidEmail(email), "Should be invalid: \(email)")
    }
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
}