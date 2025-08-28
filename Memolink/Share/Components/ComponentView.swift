import SwiftUI

struct ComponentView<Content: View>: View {
  var title: LocalizedStringKey
  var subtitle: LocalizedStringKey
  var buttonName: LocalizedStringKey
  var isEnabled: Bool
  var isLoading: Bool
  var iconType: IconType
  var action: () -> Void
  var content: () -> Content

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack {
        iconType.view()
          .padding(.bottom, 32)

        VStack(spacing: 8) {
          Text(title)
            .customFont(weight: .semiBold, size: 24)
            .foregroundStyle(.white)
          Text(subtitle)
            .customFont(weight: .regular, size: 16)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .opacity(0.6)
        }
        .padding(.bottom, 40)

        content()

        Spacer()
        PrimaryActionButton(
          title: buttonName,
          color: true,
          isEnabled: isEnabled,
          isLoading: isLoading,
          action: action
        )
        .padding(.bottom, 8)
      }
      .padding(.top, 100)
      .padding(.horizontal, 16)
    }
  }
}

// MARK: - IconType
enum IconType {
  case icon(Image)
  case imagePicker(Binding<UIImage?>)

  @ViewBuilder
  func view() -> some View {
    switch self {
    case .icon(let image):
      image
          .resizable()
          .scaledToFill()
          .frame(width: 64, height: 64)
          .foregroundStyle(.accent)

    case .imagePicker(let binding):
        ImagePicker(selectedImage: binding)
    }
  }
}

// MARK: - Preview
#Preview {
  ComponentView(
    title: "Telefon raqamingizni kiriting",
    subtitle: "Shaxsiy hisobga kirish uchun telefon raqamingizni kiriting",
    buttonName: "Kodni olish",
    isEnabled: true,
    isLoading: false,
    iconType: .icon(Image(.iconCall)),
    action: {},
    content: {
      Text("New page")
        .foregroundStyle(.white)
    }
  )
}
