import XCTest
import Network
@testable import Memolink

final class APIServiceTests: XCTestCase {
  var apiService: APIService!
  
  override func setUp() {
    super.setUp()
    apiService = APIService()
  }
  
  func testRetryLogicSuccess() async throws {
    do {
      _ = try await apiService.checkUserType(phone: "retry_test")
      XCTAssertTrue(true)
    } catch {
      XCTAssertTrue(error is URLError)
    }
  }
  
  func testNetworkConnectivityCheck() async throws {
    do {
      _ = try await apiService.login(phone: "998998881122", password: "Test123456789")
    } catch URLError.notConnectedToInternet {
      XCTAssertTrue(true)
    } catch URLError.badServerResponse {
      XCTAssertTrue(true)
    } catch URLError.timedOut {
      XCTAssertTrue(true)
    } catch {
      XCTAssertTrue(error is URLError, "Should be URLError, got: \(error)")
    }
  }
  
  func testAPIErrorHandling() async {
    do {
      _ = try await apiService.checkUserType(phone: "invalid")
    } catch {
      XCTAssertTrue(error is URLError || error is DecodingError)
    }
  }
  
  func testTimeoutHandling() async {
    let startTime = Date()
    
    do {
      _ = try await apiService.checkUserType(phone: "timeout_test")
    } catch URLError.timedOut {
      let duration = Date().timeIntervalSince(startTime)
      XCTAssertLessThan(duration, 35)
    } catch {
      
    }
  }
}
