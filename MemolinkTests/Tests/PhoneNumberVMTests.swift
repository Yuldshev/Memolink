import XCTest
@testable import Memolink

final class PhoneNumberVMTests: XCTestCase {
  
  // MARK: - Phone Format Tests
  func testValidPhoneFormat() {
    let validPhones = [
      "998990573713",
      "998901234567", 
      "998887654321"
    ]
    
    for phone in validPhones {
      XCTAssertEqual(phone.count, 12, "Phone should be 12 digits: \(phone)")
      XCTAssertTrue(phone.hasPrefix("998"), "Phone should start with 998: \(phone)")
    }
  }
  
  func testInvalidPhoneFormat() {
    let invalidPhones = [
      "99899057371",    // 11 digits
      "9989905737133",  // 13 digits
      "997990573713",   // Wrong prefix (but 12 digits)
      "",               // Empty
      "123"            // Too short
    ]
    
    for phone in invalidPhones {
      let isValidLength = phone.count == 12
      let hasValidPrefix = phone.hasPrefix("998")
      let isValidPhone = isValidLength && hasValidPrefix
      
      XCTAssertFalse(isValidPhone, "Phone should not be valid: \(phone)")
    }
  }
}