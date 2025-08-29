import SwiftUI

struct PasswordView: View {
  @State private var vm: PasswordVM
  @FocusState private var focusField: Field?
  
  init(router: OnboardingCoordinator) {
    self._vm = State(wrappedValue: PasswordVM(router: router))
  }

  var body: some View {
    ComponentView(
      title: "Create password",
      subtitle: "Create a password for your account",
      buttonName: "Continue",
      isEnabled: vm.isValid,
      isLoading: vm.isLoading,
      iconType: .icon(Image(.iconLock)),
      isPaddingTop: true,
      action: { vm.next() },
      content: {
        VStack(spacing: 24) {
          VStack(spacing: 8) {
            LabelTextField(
              title: "Create password",
              text: $vm.pass,
              textContentType: .password
            )
              .focused($focusField, equals: .pass)
              .submitLabel(.next)
              .onSubmit { focusField = .confirmPass }
            
            if !vm.pass.isEmpty && vm.confirmPass.isEmpty {
              PasswordProgress(strength: vm.passwordStrength)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
          }
          .animation(.easeInOut, value: vm.pass.isEmpty)
          .animation(.easeInOut, value: vm.confirmPass.isEmpty)
          
          LabelTextField(
            title: "Confirm password",
            text: $vm.confirmPass,
            textContentType: .password
          )
            .focused($focusField, equals: .confirmPass)
            .submitLabel(.done)
            .onSubmit { focusField = nil }
          
          Group {
            if let error = vm.errorMessage {
              Text(error)
                .foregroundStyle(.white)
                .customFont(weight: .regular, size: 14)
                .multilineTextAlignment(.center)
                .opacity(0.6)
            }
          }
          .animation(.easeInOut, value: vm.errorMessage)
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
  PasswordView(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
