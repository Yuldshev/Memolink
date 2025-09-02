import Foundation

// MARK: - Response Models
struct APIResponse<T: Codable>: Codable {
  let success: Bool
  let message: String?
  let data: T?
  let errorCode: Int?
  let timestamp: String
  let statusCode: Int
  let path: String?
  let errors: [String]?
}

struct UserTypeData: Codable {
  let userType: String
}

struct VerificationData: Codable {
  let success: Bool
  let message: String?
}

struct RegisterData: Codable {
  let phoneNumber: String
  let email: String
  let firstName: String
  let lastName: String
  let userId: String
  let status: String
}

struct LoginData: Codable {
  let accessToken: String
  let expiresIn: Int
  let refreshExpiresIn: Int
  let refreshToken: String
  let tokenType: String
  let sessionState: String
  let scope: String
}

struct TokenData: Codable {
  let accessToken: String
  let expiresIn: Int
  let refreshExpiresIn: Int
  let refreshToken: String
  let tokenType: String
  let sessionState: String
  let scope: String
}
