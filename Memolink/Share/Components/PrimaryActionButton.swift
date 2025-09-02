import SwiftUI

struct PrimaryActionButton: View {
  var title: LocalizedStringKey
  var style: ButtonStyleType = .primary
  var isLoading: Bool
  var action: () -> Void
  
  private var colorBG: Color {
    isLoading ? style.loadingColor : style.activeColor
  }

  var body: some View {
    Button(action: action) {
      ZStack {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text(title)
            .customFont(weight: .semiBold, size: 17)
            .foregroundStyle(.white)
        }
      }
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(colorBG)
        .clipShape(Capsule())
    }
    .buttonStyle(.plain)
    .disabled(isLoading)
    .animation(.smooth(duration: 0.3), value: isLoading)
  }
}

extension PrimaryActionButton {
  enum ButtonStyleType {
    case primary, secondary, destructive
    
    var activeColor: Color {
      switch self {
      case .primary:
        return .primary500
      case .secondary:
        return .neutral800
      case .destructive:
        return .appRed
      }
    }
    
    var loadingColor: Color {
      switch self {
      case .primary:
        return .primary700
      case .secondary:
        return .neutral600
      case .destructive:
        return .appRed
      }
    }
  }
}

#Preview {
  @Previewable @State var isLoading: Bool = false

  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      PrimaryActionButton(title: "Login", isLoading: isLoading) {}
    }
    .padding()
  }
}
