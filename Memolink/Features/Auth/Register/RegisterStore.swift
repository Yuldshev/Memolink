import SwiftUI

@Observable
final class RegisterStore {
  var phone = ""
  var firstName = ""
  var lastName = ""
  var email = ""
  var password = ""
  var avatar: Data?
  
  func createUser() -> User {
    User(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      avatar: avatar
    )
  }
  
  var isDataComplete: Bool {
    !phone.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty
  }
  
  func reset() {
    phone = ""
    firstName = ""
    lastName = ""
    email = ""
    password = ""
    avatar = nil
  }
}
