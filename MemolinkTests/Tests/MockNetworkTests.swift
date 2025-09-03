import XCTest
import Network
@testable import Memolink

final class MockNetworkTests: XCTestCase {
  var mockSession: MockURLSession!
  
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
  }
  
  func testSuccessfulLoginResponse() throws {
    let expectedResponse = """
      {
        "success": true,
        "message": "Success",
        "data": {
          "accessToken": "mock_token",
          "expiresIn": 600,
          "refreshExpiresIn": 15479616,
          "refreshToken": "mock_refresh",
          "tokenType": "Bearer",
          "sessionState": "session",
          "scope": "profile"
        },
        "errorCode": null,
        "timestamp": "2025-09-03T12:09:08.947927195",
        "statusCode": 200,
        "path": null,
        "errors": null
      }
      """
    
    mockSession.data = expectedResponse.data(using: .utf8)
    mockSession.response = HTTPURLResponse(
      url: URL(string: "http://test.com")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    
    let decoder = JSONDecoder()
    let apiResponse = try decoder.decode(APIResponse<LoginData>.self, from: mockSession.data!)
    
    XCTAssertTrue(apiResponse.success)
    XCTAssertEqual(apiResponse.data?.accessToken, "mock_token")
    XCTAssertEqual(apiResponse.data?.refreshToken, "mock_refresh")
  }
  
  func testErrorResponse() throws {
    let errorResponse = """
      {
        "success": false,
        "message": "Invalid credentials",
        "data": null,
        "errorCode": 400,
        "timestamp": "7861",
        "statusCode": 400,
        "path": "refresh",
        "errors": null
      }
      """
    
    mockSession.data = errorResponse.data(using: .utf8)
    mockSession.response = HTTPURLResponse(
      url: URL(string: "http://test.com")!,
      statusCode: 401,
      httpVersion: nil,
      headerFields: nil
    )
    
    let decoder = JSONDecoder()
    let apiResponse = try decoder.decode(APIResponse<LoginData>.self, from: mockSession.data!)
    
    XCTAssertFalse(apiResponse.success)
    XCTAssertEqual(apiResponse.message, "Invalid credentials")
    XCTAssertNil(apiResponse.data)
  }
  
  func testNetworkError() {
    mockSession.error = URLError(.notConnectedToInternet)
    
    XCTAssertEqual((mockSession.error as? URLError)?.code, .notConnectedToInternet)
  }
  
  func testInvalidJSONResponse() {
    mockSession.data = "Invalid json".data(using: .utf8)
    mockSession.response = HTTPURLResponse(
      url: URL(string: "http://test.com")!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )
    
    let decoder = JSONDecoder()
    XCTAssertThrowsError(try decoder.decode(APIResponse<LoginData>.self, from: mockSession.data!)) { error in
      XCTAssertTrue(error is DecodingError)
    }
  }
}
