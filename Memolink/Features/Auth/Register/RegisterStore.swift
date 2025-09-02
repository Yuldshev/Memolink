import SwiftUI

@Observable
final class RegisterStore {
  var phone = ""
  var firstName = ""
  var lastName = ""
  var email = ""
  var password = ""
  var avatar: Data?
  
  func reset() {
    phone = ""
    firstName = ""
    lastName = ""
    email = ""
    password = ""
    avatar = nil
  }
}
