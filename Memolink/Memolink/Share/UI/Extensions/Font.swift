import SwiftUI

enum FontWeight: String {
  case regular = "Onest-Regular"
  case medium = "Onest-Medium"
  case semiBold = "Onest-SemiBold"
}

enum FontSize: CGFloat {
  case size32 = 32
  case size28 = 28
  case size24 = 24
  case size20 = 20
  case size18 = 18
  case size16 = 16
  case size14 = 14
  case size12 = 12
  case size10 = 10
}

extension View {
  func customFont(weight: FontWeight, size: FontSize) -> some View {
    self.font(.custom(weight.rawValue, size: size.rawValue))
  }
}
