import SwiftUI

@Observable
final class RegisterStore {
  var phone = ""
  var firstName = ""
  var lastName = ""
  var password = ""
  var avatar: Data?
  
  func reset() {
    phone = ""
    firstName = ""
    lastName = ""
    password = ""
    avatar = nil
  }
}
