import Foundation
import Alamofire

final class APIClient {
  private let session = URLSession.shared
  private let baseURL = "http://167.86.104.55:8888"
  
  func request<T: Codable>(
    _ endpoint: String,
    method: HTTPMethod = .get,
    parameters: [String: Any]? = nil,
    token: String? = nil
  ) async throws -> T {
    let request = try buildRequest(
      endpoint: endpoint,
      method: method,
      parameters: parameters,
      token: token
    )
    let data = try await performRequest(request)
    return try decodeResponse(data)
  }
  
  // MARK: - Private Methods
  private func buildRequest(
    endpoint: String,
    method: HTTPMethod,
    parameters: [String: Any]? = nil,
    token: String?
  ) throws -> URLRequest {
    guard let url = URL(string: baseURL + endpoint) else {
      throw NetworkError.server
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if let token = token {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    if let parameters = parameters, method != .get {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    }
    
    return request
  }
  
  private func performRequest(_ request: URLRequest) async throws -> Data {
    do {
      let (data, response) = try await session.data(for: request)
      try validateResponse(response)
      return data
    } catch is URLError {
      throw NetworkError.noConnection
    }
  }
  
  private func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.server
    }
    
    switch httpResponse.statusCode {
    case 200...299:
      break
    case 401:
      throw NetworkError.authentication
    case 400...499:
      throw NetworkError.clientError
    case 500...599:
      throw NetworkError.server
    default:
      throw NetworkError.server
    }
  }
  
  private func decodeResponse<T: Codable>(_ data: Data) throws -> T {
    if let result = try? JSONDecoder().decode(T.self, from: data) {
      return result
    }
    
    let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
    guard apiResponse.success, let result = apiResponse.data else {
      throw NetworkError.server
    }
    return result
  }
}
