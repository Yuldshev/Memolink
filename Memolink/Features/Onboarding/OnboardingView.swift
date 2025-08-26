import SwiftUI

struct OnboardingView: View {
  @State private var locale: LocaleApp = .en
  @State private var showSelectLocale = false

  var body: some View {
    ZStack {
      OnboardingOverlay()
      
      VStack(alignment: .leading, spacing: 32) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Easy to remember with Memolink")
            .foregroundStyle(.white)
            .customFont(weight: .semiBold, size: 28)
          Text("Pictures, emotions, moments — all for you")
            .foregroundStyle(.neutral300)
            .customFont(weight: .regular, size: 18)
        }

        VStack(spacing: 12) {
          PrimaryActionButton(
            title: "Sign Up",
            color: true,
            isEnabled: true,
            isLoading: false
          ) {}

          PrimaryActionButton(
            title: "Sign In",
            color: false,
            isEnabled: true,
            isLoading: false
          ) {}
        }
      }
      .padding(.horizontal, 16)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .overlay(alignment: .topTrailing) { buttonLocale }
    .sheet(isPresented: $showSelectLocale) {
      ChooseLocale(locale: $locale)
        .presentationDetents([.height(360)])
        .presentationDragIndicator(.visible)
    }
  }

  private var buttonLocale: some View {
    Button { showSelectLocale.toggle() } label: {
      HStack {
        Image(.iconArrowDown)
        Text(locale.rawValue.capitalized)
          .customFont(weight: .medium, size: 18)
      }
      .offset(x: -8)
      .foregroundStyle(.white)
      .frame(width: 88, height: 44)
      .background(.thinMaterial)
      .clipShape(Capsule())
      .padding(.trailing, 16)
    }
  }
}

#Preview {
  OnboardingView()
}
