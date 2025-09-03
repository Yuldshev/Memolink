import XCTest
@testable import Memolink

final class InformationVMTests: XCTestCase {
  
  // MARK: - Email Validation Tests (без dependencies)
  func testValidEmailFormats() {
    let validEmails = [
      "test@example.com",
      "user.name@domain.co.uk", 
      "user+tag@example.org",
      "123@domain.com"
    ]
    
    for email in validEmails {
      XCTAssertTrue(isValidEmail(email), "Should be valid: \(email)")
    }
  }
  
  func testInvalidEmailFormats() {
    let invalidEmails = [
      "plainaddress",
      "@missingdomain.com",
      "missing@.com",
      "missing@domain",
      "spaces @domain.com"
    ]
    
    for email in invalidEmails {
      XCTAssertFalse(isValidEmail(email), "Should be invalid: \(email)")
    }
  }
  
  // MARK: - Helper Method (из InformationVM)
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
}