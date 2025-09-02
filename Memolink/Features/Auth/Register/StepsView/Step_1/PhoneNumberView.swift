import SwiftUI

struct PhoneNumberView: View {
  @State private var vm: PhoneNumberVM
  
  init(router: OnboardingCoordinator) {
    self._vm = State(wrappedValue: PhoneNumberVM(router: router))
  }

  var body: some View {
    ComponentView(
      title: "Enter your phone number",
      subtitle: "Enter your phone number to access your account",
      buttonName: "Get code",
      isLoading: vm.isLoading,
      iconType: .icon(Image(.iconCall)),
      isPaddingTop: true,
      action: { vm.next() },
      content: {
        LabelTextField(
          title: "Phone number",
          text: $vm.displayPhone,
          keyboardType: .phonePad,
          textContentType: .telephoneNumber
        )
        .onChange(of: vm.displayPhone) { _, newValue in
          vm.updatePhone(newValue)
        }
      }
    )
  }
}

#Preview {
  PhoneNumberView(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
