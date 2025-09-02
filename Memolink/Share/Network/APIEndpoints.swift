import Foundation
import Alamofire

struct APIConfig {
  static let baseURL = "http://167.86.104.55:8888/api"
}

enum APIEndpoints {
  case userTypeCheck
  case verifyPhoneNumber
  case register
  case refresh
  case login
  
  var path: String {
    switch self {
    case .userTypeCheck:
      return "/auth/user-type-check"
    case .verifyPhoneNumber:
      return "/auth/verify-phone-number"
    case .register:
      return "/auth/register"
    case .refresh:
      return "/auth/refresh"
    case .login:
      return "/auth/login"
    }
  }
  
  var url: URL {
    guard let url = URL(string: APIConfig.baseURL + path) else {
      fatalError("Invalid URL for endpoint: \(path)")
    }
    return url
  }
  
  var method: HTTPMethod {
    return .post
  }
  
  var headers: HTTPHeaders {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  }
}
