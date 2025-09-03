import Foundation

final class MockURLSession {
  var data: Data?
  var response: URLResponse?
  var error: Error?
}
