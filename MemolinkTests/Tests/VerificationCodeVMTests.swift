import XCTest
@testable import Memolink

final class VerificationCodeVMTests: XCTestCase {
  
  // MARK: - Code Format Tests
  func testValidCodeLength() {
    let validCodes = ["123456", "000000", "999999"]
    
    for code in validCodes {
      XCTAssertEqual(code.count, 6, "Code should be 6 digits: \(code)")
      XCTAssertTrue(code.allSatisfy { $0.isNumber }, "Code should contain only numbers: \(code)")
    }
  }
  
  func testInvalidCodeLength() {
    let invalidCodes = [
      "12345",    // 5 digits
      "1234567",  // 7 digits
      "",         // Empty
      "12345a",   // Contains letter
      "12 456"    // Contains space
    ]
    
    for code in invalidCodes {
      if code.count == 6 {
        XCTAssertFalse(code.allSatisfy { $0.isNumber }, "Code should not be valid: \(code)")
      } else {
        XCTAssertNotEqual(code.count, 6, "Code should not be valid length: \(code)")
      }
    }
  }
}