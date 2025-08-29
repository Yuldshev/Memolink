import SwiftUI

struct VerificationCodeView: View {
  @State private var vm: VerificationCodeVM
  
  init(router: OnboardingCoordinator) {
    self._vm = State(wrappedValue: VerificationCodeVM(router: router))
  }
  
  var body: some View {
    ComponentView(
      title: "Code verification",
      subtitle: "Enter the 4-digit code sent to your number",
      buttonName: "Verify",
      isEnabled: vm.isValid,
      isLoading: vm.isLoading,
      iconType: .icon(Image(.iconChat)),
      isPaddingTop: true,
      action: { vm.next() },
      content: {
        VStack(spacing: 12) {
          VerificationInput(code: $vm.code)
          
          Group {
            if vm.timeRemaining > 0 {
              Text("After \(vm.timeRemaining)s, you can get the new code")
                .foregroundStyle(.white)
            } else {
              Button("Resend code") {
                vm.resetTimer()
              }
            }
          }
          .customFont(weight: .regular, size: 14)
          .animation(.easeInOut(duration: 0.2), value: vm.timeRemaining > 0)
        }
      }
    )
    .onAppear(perform: vm.startTimer)
    .onDisappear(perform: vm.stopTimer)
  }
}

#Preview {
  VerificationCodeView(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
