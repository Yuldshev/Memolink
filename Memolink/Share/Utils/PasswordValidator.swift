import Foundation

struct PasswordValidator {
  static func validate(_ password: String) -> Bool {
    return password.count >= 8 &&
    password.contains { $0.isLowercase } &&
    password.contains { $0.isUppercase } &&
    password.contains { $0.isNumber }
  }
  
  static func strength(_ password: String) -> Int {
    guard !password.isEmpty else { return 0 }
    
    let checks = [
      password.count >= 8,
      password.contains { $0.isLowercase },
      password.contains { $0.isUppercase },
      password.contains { $0.isNumber }
    ]
    
    return checks.filter { $0 }.count
  }
}
