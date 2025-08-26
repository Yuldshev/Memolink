import SwiftUI

struct PrimaryActionButton: View {
  var title: LocalizedStringKey
  var isEnabled: Bool
  var isLoading: Bool
  var action: () -> Void

  @State private var isPressed: Bool = false

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
        .background(buttonBG)
        .clipShape(Capsule())
        .scaleEffect(isPressed ? 0.95 : 1)
    }
    .buttonStyle(.plain)
    .simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .onChanged { _ in
          if !isPressed && isEnabled && !isLoading {
            withAnimation(.easeOut(duration: 0.1)) {
              isPressed = true
            }
          }
        }
        .onEnded { _ in
          if isPressed {
            withAnimation(.easeIn(duration: 0.1)) {
              isPressed = false
            }
          }
        }
    )
    .animation(.smooth(duration: 0.3), value: isLoading)
    .animation(.smooth(duration: 0.2), value: isEnabled)
    .animation(.smooth(duration: 0.2), value: isPressed)
    .disabled(!isEnabled || isLoading)
  }

  private var buttonBG: Color {
    if !isEnabled || isLoading {
      return .neutral600
    }
    return isPressed ? .primary600 : .primary500
  }
}

#Preview {
  @Previewable @State var isEnabled: Bool = true
  @Previewable @State var isLoading: Bool = false

  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      PrimaryActionButton(
        title: "Login",
        isEnabled: isEnabled,
        isLoading: isLoading
      ) {}
        .padding()

      HStack(spacing: 60) {
        Button("Enabled") {
          isEnabled.toggle()
        }

        Button("Loading") {
          isLoading.toggle()
        }
      }
    }
  }
}
