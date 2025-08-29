import SwiftUI

struct User: Codable {
  let phone: String
  let firstName: String
  let lastName: String
  let email: String
  let password: String
  let avatar: Data?
  
  var image: UIImage? {
    avatar.flatMap { UIImage(data: $0) }
  }
}
