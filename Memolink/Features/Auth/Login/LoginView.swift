import SwiftUI

struct LoginView: View {
  @State private var vm: LoginVM
  @FocusState private var focusField: Field?

  init(router: OnboardingCoordinator) {
    self._vm = State(wrappedValue: LoginVM(router: router))
  }
  
  var body: some View {
    ComponentView(
      title: "Sign In",
      subtitle: "Enter your phone number and password to sign in",
      buttonName: "Verify",
      isLoading: vm.isLoading,
      iconType: .icon(Image(.iconUser)),
      isPaddingTop: true,
      action: { vm.login() },
      content: {
        VStack(spacing: 24) {
          LabelTextField(
            title: "Phone number",
            text: $vm.displayPhone,
            textContentType: .telephoneNumber
          )
            .focused($focusField, equals: .phone)
            .submitLabel(.next)
            .onSubmit { focusField = .pass }
            .onChange(of: vm.displayPhone) { _, newValue in
              vm.updatePhone(newValue)
            }
          
          LabelTextField(
            title: "Password",
            text: $vm.password,
            textContentType: .password
          )
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
  LoginView(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
