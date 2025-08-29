import SwiftUI

struct ComponentView<Content: View>: View {
  var title: LocalizedStringKey
  var subtitle: LocalizedStringKey
  var buttonName: LocalizedStringKey
  var isEnabled: Bool
  var isLoading: Bool
  var iconType: IconType
  var isPaddingTop: Bool
  var action: () -> Void
  var content: () -> Content

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 0) {
        iconType.view()
          .padding(.bottom, 32)

        VStack(spacing: 8) {
          Text(title)
            .customFont(weight: .semiBold, size: 24)
            .lineLimit(1)
            .foregroundStyle(.white)
          Text(subtitle)
            .frame(width: 310)
            .customFont(weight: .regular, size: 16)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .foregroundStyle(.neutral300)
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
      .padding(.top, isPaddingTop ? 80 : 76)
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
    isPaddingTop: true,
    action: {},
    content: {
      Text("New page")
        .foregroundStyle(.white)
    }
  )
}

#Preview {
  ComponentView(
    title: "Telefon raqamingizni kiriting",
    subtitle: "Shaxsiy hisobga kirish uchun telefon raqamingizni kiriting",
    buttonName: "Kodni olish",
    isEnabled: true,
    isLoading: false,
    iconType: .imagePicker(.constant(.img1)),
    isPaddingTop: false,
    action: {},
    content: {
      Text("New page")
        .foregroundStyle(.white)
    }
  )
}
