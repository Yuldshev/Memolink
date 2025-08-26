import SwiftUI

struct PhoneNumberView: View {
  @State private var phone = ""

  var body: some View {
    ComponentView(
      title: "Enter your phone number",
      subtitle: "Enter your phone number to access your account",
      buttonName: "Get code",
      isEnabled: true,
      isLoading: false,
      iconType: .icon(Image(.iconCall)),
      action: {
      },
      content: {
        LabelTextField(
          title: "Phone number",
          text: $phone,
          textContentType: .telephoneNumber
        )
      }
    )
  }
}

#Preview {
  PhoneNumberView()
}
