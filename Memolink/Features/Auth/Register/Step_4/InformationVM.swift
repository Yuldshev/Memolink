import SwiftUI

@Observable
final class InformationVM {
  var avatar: UIImage?
  var firstName = ""
  var lastName = ""
  var email = ""
  var isLoading = false
  
  var isValid: Bool {
    return !firstName.isEmpty && !lastName.isEmpty && isValidEmail(email)
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
  
}
