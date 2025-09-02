import SwiftUI

struct PrimaryActionButton: View {
  var title: LocalizedStringKey
  var isLoading: Bool
  var action: () -> Void

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
        .background(isLoading ? .neutral600 : .primary500)
        .clipShape(Capsule())
    }
    .buttonStyle(.plain)
    .disabled(isLoading)
    .animation(.smooth(duration: 0.3), value: isLoading)
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
