import Foundation

// MARK: - Response Models
struct APIResponse<T: Codable>: Codable {
  let success: Bool
  let data: T?
  let message: String?
}

struct UserTypeData: Codable {
  let userType: String
}

struct VerificationData: Codable {
  let success: Bool
  let message: String?
}

struct TokenData: Codable {
  let accessToken: String
  let expiresIn: Int
  let refreshToken: String
}

struct UserData: Codable {
  let phoneNumber: String
  let email: String?
  let firstName: String
  let lastName: String
  let userId: String
  let status: String
}
