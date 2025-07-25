import SwiftUI

struct CustomTextField: View {
  @Binding var text: String
  var placeholder: String
  var isError = false

  @FocusState private var isFocused: Bool

  var colorBorder: Color {
    if isError {
      .appRed
    } else if isFocused {
      Color.accentColor
    } else {
      .clear
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(placeholder)
        .customFont(weight: .regular, size: .size12)
        .foregroundStyle(.white.opacity(0.6))

      TextField("", text: $text)
        .customFont(weight: .medium, size: .size16)
        .focused($isFocused)
        .foregroundStyle(.white)
    }
    .padding(.horizontal, 12)
    .frame(height: 56)
    .background(.appGray)
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(colorBorder, lineWidth: 2)
    }
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      CustomTextField(text: .constant(""), placeholder: "Familiyangizni kiriting")
      CustomTextField(text: .constant("John Doe"), placeholder: "Familiyangizni kiriting")
      CustomTextField(text: .constant("John Doe"), placeholder: "Familiyangizni kiriting", isError: true)
    }
  }
}
