import SwiftUI

struct InformationView: View {
  @State private var vm: InformationVM
  @FocusState private var focusedField: Field?
  
  init(router: OnboardingCoordinator) {
    self._vm = State(wrappedValue: InformationVM(router: router))
  }

  var body: some View {
    ComponentView(
      title: "Personal information",
      subtitle: "Upload your photo and enter your information",
      buttonName: "Continue",
      isLoading: vm.isLoading,
      iconType: .imagePicker($vm.avatar),
      isPaddingTop: false,
      action: { vm.complete()
      },
      content: {
        VStack(spacing: 24) {
          LabelTextField(title: "First name", text: $vm.firstName, textContentType: .givenName)
            .focused($focusedField, equals: .firstName)
            .submitLabel(.next)
            .onSubmit { focusedField = .lastName }
          LabelTextField(title: "Last name", text: $vm.lastName, textContentType: .familyName)
            .focused($focusedField, equals: .lastName)
            .submitLabel(.next)
            .onSubmit { focusedField = nil }
        }
      }
    )
  }
}

// MARK: - Focus Field
private enum Field {
  case firstName, lastName
}

// MARK: - Preview
#Preview {
  InformationView(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
