import SwiftUI

struct VerificationCodeView: View {
  @State private var code = ""
  @State private var timeRemaining = 60
  @State private var timer: Timer?
  
  var body: some View {
    ComponentView(
      title: "Code verification",
      subtitle: "Enter the 4-digit code sent to your number",
      buttonName: "Verify",
      isEnabled: true,
      isLoading: false,
      iconType: .icon(Image(.iconChat)),
      action: {},
      content: {
        VStack(spacing: 12) {
          VerificationInput(code: $code)
          
          Group {
            if timeRemaining > 0 {
              Text("After \(timeRemaining)s, you can get the new code")
                .foregroundStyle(.white)
            } else {
              Button("Resend code") {
                code = ""
                timeRemaining = 60
                
              }
            }
          }
          .customFont(weight: .regular, size: 14)
          .animation(.easeInOut(duration: 0.2), value: timeRemaining > 0)
        }
      }
    )
    .onAppear(perform: startTimer)
    .onDisappear { timer?.invalidate() }
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        timer?.invalidate()
      }
    }
  }
}

#Preview {
  VerificationCodeView()
}
