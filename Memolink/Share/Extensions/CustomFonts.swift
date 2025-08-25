import SwiftUI

enum FontWeight: String {
  case regular = "Onest-Regular"
  case medium = "Onest-Medium"
  case semiBold = "Onest-SemiBold"
}

extension View {
  func customFont(weight: FontWeight, size: CGFloat) -> some View {
    self.font(.custom(weight.rawValue, size: size))
  }
}
