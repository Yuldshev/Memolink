import Foundation
import Alamofire
import Network

protocol APIServiceProtocol {
  func checkUserType(phone: String) async throws -> UserTypeData
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData
  func login(phone: String, password: String) async throws -> LoginData
  func refresh(token: String) async throws -> TokenData
}

actor APIService: APIServiceProtocol {
  private let session: Session
  private let monitor = NWPathMonitor()
  private var isConnected = true
  
  init() {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 60
    self.session = Session(configuration: config)
    
    monitor.pathUpdateHandler = { path in
      Task { await self.updateConnection(path.status == .satisfied) }
    }
    monitor.start(queue: .global())
  }
  
  // MARK: - Open methods
  func checkUserType(phone: String) async throws -> UserTypeData {
    try await retryRequest {
      try await self.request(.userTypeCheck, ["phoneNumber": phone])
    }
  }
  
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData {
    let response: APIResponse<VerificationData> = try await retryRequest {
      try await self.requestRaw(.verifyPhoneNumber, ["phoneNumber": phone, "otp": otp])
    }
    return VerificationData(success: response.success, message: response.message)
  }
  
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData {
    try await retryRequest {
      try await self.request(.register, [
        "phoneNumber": phone,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "password": password
      ])
    }
  }
  
  func login(phone: String, password: String) async throws -> LoginData {
    try await retryRequest {
      try await self.request(.login, ["phoneNumber": phone, "password": password])
    }
  }
  
  func refresh(token: String) async throws -> TokenData {
    try await retryRequest {
      try await self.request(.refresh, ["refreshToken": token])
    }
  }
  
  // MARK: - Private methods
  private func retryRequest<T>(_ operation: @escaping () async throws -> T) async throws -> T {
    guard isConnected else { throw URLError(.notConnectedToInternet) }
    
    for attempt in 1...3 {
      do {
        return try await operation()
      } catch {
        if attempt == 3 { throw error }
        try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 500_000_000))
      }
    }
    throw URLError(.timedOut)
  }
  
  private func request<T: Codable>(_ endpoint: APIEndpoints, _ parameters: [String: Any]) async throws -> T {
    let response: APIResponse<T> = try await requestRaw(endpoint, parameters)
    guard let data = response.data else { throw URLError(.badServerResponse) }
    return data
  }
  
  private func requestRaw<T: Codable>(_ endpoint: APIEndpoints, _ parameters: [String: Any]) async throws -> APIResponse<T> {
    try await session.request(
      endpoint.url,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    ).serializingDecodable(APIResponse<T>.self).value
  }
  
  private func updateConnection(_ connect: Bool) {
    isConnected = connect
  }
}
