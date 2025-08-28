import SwiftUI

struct PhoneNumberView: View {
  @State private var vm = PhoneNumberVM()
  @Environment(OnboardingRouter.self) private var router

  var body: some View {
    ComponentView(
      title: "Enter your phone number",
      subtitle: "Enter your phone number to access your account",
      buttonName: "Get code",
      isEnabled: vm.isValid,
      isLoading: vm.isLoading,
      iconType: .icon(Image(.iconCall)),
      action: { router.navigate(to: .verificationCode) },
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
  PhoneNumberView()
    .environment(OnboardingRouter(coordinator: AppCoordinator()))
}
