import SwiftUI

struct CustomSmallButton: View {
  var selectIcon: ButtonIcon
  var action: () -> Void

  var body: some View {
    Button { action() } label: {
      Group {
        Image(selectIcon.iconName)
          .foregroundStyle(.white)
      }
      .frame(maxWidth: 44, maxHeight: 44)
      .background(selectIcon.colorBG)
      .clipShape(Circle())
    }
  }
}

// MARK: - Enum Button Icon
extension CustomSmallButton {
  enum ButtonIcon: String {
    case plus, xmark

    var iconName: String {
      switch self {
      case .plus: return "appPlus"
      case .xmark: return "appXmark"
      }
    }

    var colorBG: Color {
      switch self {
      case .plus: return .accent
      case .xmark: return .appLightGray
      }
    }
  }
}

// MARK: - Preview
#Preview {
  ZStack {
    Color.black.ignoresSafeArea()

    HStack {
      CustomSmallButton(selectIcon: .plus, action: {})
      CustomSmallButton(selectIcon: .xmark, action: {})
    }
  }
}
