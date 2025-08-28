import SwiftUI

struct InformationView: View {
  @State private var vm = InformationVM()
  @FocusState private var focusedField: Field?
  @Environment(OnboardingRouter.self) private var router

  var body: some View {
    ComponentView(
      title: "Personal information",
      subtitle: "Upload your photo and enter your information",
      buttonName: "Continue",
      isEnabled: vm.isValid,
      isLoading: vm.isLoading,
      iconType: .imagePicker($vm.avatar),
      action: { router.completeRegistation() },
      content: {
        VStack(spacing: 24) {
          LabelTextField(title: "First name", text: $vm.firstName, textContentType: .givenName)
            .focused($focusedField, equals: .firstName)
            .submitLabel(.next)
            .onSubmit { focusedField = .lastName }
          LabelTextField(title: "Last name", text: $vm.lastName, textContentType: .familyName)
            .focused($focusedField, equals: .lastName)
            .submitLabel(.next)
            .onSubmit { focusedField = .email }
          LabelTextField(title: "Email", text: $vm.email, textContentType: .emailAddress)
            .focused($focusedField, equals: .email)
            .submitLabel(.done)
            .onSubmit { focusedField = nil }
        }
      }
    )
  }
}

// MARK: - Focus Field
private enum Field {
  case firstName, lastName, email
}

// MARK: - Preview
#Preview {
  InformationView()
    .environment(OnboardingRouter(coordinator: AppCoordinator()))
}
