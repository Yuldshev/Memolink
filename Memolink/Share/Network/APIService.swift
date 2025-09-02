import Foundation
import Alamofire

actor APIService {
  private let session = Session()
  
  func checkUserType(phone: String) async throws -> UserTypeData {
    try await request(.userTypeCheck, ["phoneNumber": phone])
  }
  
  func verifyPhone(_ phone: String, otp: String) async throws -> VerificationData {
    let response: APIResponse<VerificationData> = try await requestRaw(
      .verifyPhoneNumber,
      ["phoneNumber": phone, "otp": otp]
    )
    return VerificationData(success: response.success, message: response.message)
  }
  
  func register(phone: String, firstName: String, lastName: String, email: String, password: String) async throws -> RegisterData {
    try await request(.register, [
      "phoneNumber": phone,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "password": password
    ])
  }
  
  func login(phone: String, password: String) async throws -> LoginData {
    try await request(.login, ["phoneNumber": phone, "password": password])
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
    )
      .serializingDecodable(APIResponse<T>.self).value
  }
}
