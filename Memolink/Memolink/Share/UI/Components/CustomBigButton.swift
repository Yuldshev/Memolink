import SwiftUI

struct CustomBigButton: View {
  var text: String
  var action: () -> Void
  var selectIcon: ButtonIcon?

  var body: some View {
    Button { action() } label: {
      HStack {
        if let selectIcon = selectIcon {
          Image(selectIcon.rawValue)
            .foregroundStyle(selectIcon == .trash ? .appRed : .white)
        }
        Text(text)
          .foregroundStyle(selectIcon == .trash ? .appRed : .white)
          .customFont(weight: .semiBold, size: .size18)
      }
      .frame(maxWidth: .infinity, minHeight: 56)
      .background(selectIcon?.color ?? .accent)
      .clipShape(Capsule())
    }
  }
}

// MARK: - Enum Button Icon
extension CustomBigButton {
  enum ButtonIcon: String {
    case pensil = "appPencil"
    case trash = "appTrash"

    var color: Color {
      switch self {
      case .pensil: return .accent
      case .trash: return .appRed.opacity(0.2)
      }
    }
  }
}

// MARK: - Preview
#Preview {
  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      CustomBigButton(text: "Tahrirlash", action: {})
      CustomBigButton(text: "Tahrirlash", action: {}, selectIcon: .pensil)
      CustomBigButton(text: "Ochrish", action: {}, selectIcon: .trash)
    }
  }
}
