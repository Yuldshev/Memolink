import SwiftUI

struct InformationView: View {
  @State private var avatar: UIImage?
  @State private var firstName = ""
  @State private var lastName = ""

  @FocusState private var focusedField: Field?

  var body: some View {
    ComponentView(
      title: "Personal information",
      subtitle: "Upload your photo and enter your information",
      buttonName: "Continue",
      isEnabled: true,
      isLoading: false,
      iconType: .imagePicker($avatar),
      action: {},
      content: {
        VStack(spacing: 24) {
          LabelTextField(title: "First name", text: $firstName, textContentType: .givenName)
            .focused($focusedField, equals: .firstName)
            .submitLabel(.next)
            .onSubmit { focusedField = .lastName }
          LabelTextField(title: "Last name", text: $lastName, textContentType: .familyName)
            .focused($focusedField, equals: .lastName)
            .submitLabel(.done)
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
  InformationView()
}
