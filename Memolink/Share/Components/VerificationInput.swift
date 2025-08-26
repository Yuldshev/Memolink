import SwiftUI

struct VerificationInput: View {
  @Binding var code: String
  let codeLength = 5
  @FocusState private var isFocused: Bool

  var body: some View {
    ZStack {
      TextField("", text: $code)
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .focused($isFocused)
        .autocorrectionDisabled()
        .opacity(0.001)
        .onChange(of: code) { _, newValue in
          code = String(newValue.filter(\.isNumber).prefix(codeLength))
        }

      HStack(spacing: 12) {
        ForEach(0..<codeLength, id: \.self) { index in
          let hasDigit = index < code.count
          let isCurrentPosition = index == code.count && isFocused

          ZStack {
            RoundedRectangle(cornerRadius: 12)
              .fill(.neutral800)
              .frame(width: 56, height: 56)
              .overlay {
                if isCurrentPosition {
                  RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary500, lineWidth: 2)
                }
              }

            if hasDigit {
              Text(String(code[code.index(code.startIndex, offsetBy: index)]))
                .customFont(weight: .semiBold, size: 16)
                .foregroundStyle(.white)
            }
          }
        }
      }
    }
    .onTapGesture { isFocused = true }
    .animation(.easeInOut(duration: 0.2), value: code)
    .animation(.easeInOut(duration: 0.2), value: isFocused)
  }
}

#Preview {
  @Previewable @State var code = ""
  VStack {
    VerificationInput(code: $code)
  }
}
