import SwiftUI

struct PasswordView: View {
  @State private var pass = ""
  @State private var confirmPass = ""

  @FocusState private var focusField: Field?

  var body: some View {
    ComponentView(
      title: "Create password",
      subtitle: "Create a password for your account",
      buttonName: "Continue",
      isEnabled: true,
      isLoading: false,
      iconType: .icon(Image(.iconLock)),
      action: {},
      content: {
        VStack(spacing: 24) {
          VStack(spacing: 8) {
            LabelTextField(title: "Create password", text: $pass, textContentType: .password)
              .focused($focusField, equals: .pass)
              .submitLabel(.next)
              .onSubmit { focusField = .confirmPass }
            
            if !pass.isEmpty && confirmPass.isEmpty {
              PasswordProgress(count: pass.count)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
          }
          .animation(.easeInOut, value: pass.isEmpty)
          .animation(.easeInOut, value: confirmPass.isEmpty)

          LabelTextField(title: "Confirm password", text: $confirmPass, textContentType: .password)
            .focused($focusField, equals: .confirmPass)
            .submitLabel(.done)
            .onSubmit { focusField = nil }
        }
      }
    )
  }
}

// MARK: - Focus Field
private enum Field {
  case pass, confirmPass
}

// MARK: - Preview
#Preview {
  PasswordView()
}
