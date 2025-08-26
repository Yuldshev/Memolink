import SwiftUI

struct LoginView: View {
  @State private var phone = "+998"
  @State private var password = ""

  @FocusState private var focusField: Field?

  var body: some View {
    ComponentView(
      title: "Login",
      subtitle: "Enter your phone number and password to sign in",
      buttonName: "Verify",
      isEnabled: true,
      isLoading: false,
      iconType: .icon(Image(.iconUser)),
      action: {},
      content: {
        VStack(spacing: 24) {
          LabelTextField(title: "Phone number", text: $phone, textContentType: .telephoneNumber)
            .focused($focusField, equals: .phone)
            .submitLabel(.next)
            .onSubmit { focusField = .pass }
          LabelTextField(title: "Password", text: $password, textContentType: .password)
            .focused($focusField, equals: .pass)
            .submitLabel(.done)
            .onSubmit { focusField = nil }
        }
      }
    )
  }
}

// MARK: - Focus Field
private enum Field {
  case phone, pass
}

// MARK: - Preview
#Preview {
  LoginView()
}
