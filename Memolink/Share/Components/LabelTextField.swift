import SwiftUI

struct LabelTextField: View {
  let title: LocalizedStringKey
  @Binding var text: String
  var keyboardType: UIKeyboardType = .default
  var textContentType: UITextContentType

  @State private var isPasswordVisible: Bool = false
  @FocusState private var isFocused: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .customFont(weight: .regular, size: 12)
        .foregroundStyle(.neutral400)

      textFieldContent
    }
    .padding(.horizontal, 12)
    .frame(height: 64)
    .background(.black600)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .onTapGesture { isFocused.toggle() }
    .overlay(focusedBorder)
    .overlay(alignment: .trailing) { passwordToggleButton }
  }

  // MARK: - Subviews
  @ViewBuilder
  private var textFieldContent: some View {
    if isPasswordField && !isPasswordVisible {
      SecureField("", text: $text)
        .textFieldModifiers(condition: $isFocused, textContentType: textContentType)
    } else {
      TextField("", text: $text)
        .keyboardType(keyboardType)
        .textFieldModifiers(condition: $isFocused, textContentType: textContentType)
    }
  }

  private var focusedBorder: some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(isFocused ? .primary500 : .clear, lineWidth: 2)
      .animation(.easeInOut(duration: 0.2), value: isFocused)
  }

  @ViewBuilder
  private var passwordToggleButton: some View {
    if isPasswordField {
      Button { isPasswordVisible.toggle() } label: {
        Image(isPasswordVisible ? .iconEyeOff : .iconEyeOn)
          .resizable()
          .scaledToFit()
          .foregroundStyle(.neutral300)
          .frame(width: 24, height: 24)
          .padding(.trailing, 12)
      }
      .animation(.easeInOut(duration: 0.2), value: isPasswordVisible)
    }
  }

  // MARK: - Helpers
  private var isPasswordField: Bool {
    textContentType == .password
  }
}

// MARK: - ViewModifier Extension
extension View {
  func textFieldModifiers(condition: FocusState<Bool>.Binding, textContentType: UITextContentType? = nil) -> some View {
    self
      .foregroundStyle(.white)
      .customFont(weight: .medium, size: 16)
      .focused(condition)
      .textContentType(textContentType)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.none)
  }
}

#Preview {
  @Previewable @State var pass = ""
  LabelTextField(title: "Password", text: $pass, textContentType: .password)
    .padding()
}
