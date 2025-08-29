import SwiftUI

struct OnboardingView: View {
  @State private var locale: LocaleApp = .en
  @State private var showSelectLocale = false
  @Environment(OnboardingCoordinator.self) private var router
  
  var body: some View {
    ZStack {
      OnboardingOverlay()
      if showSelectLocale {
        Color.black
          .opacity(0.4)
          .ignoresSafeArea()
      }
      
      VStack(alignment: .leading, spacing: 32) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Easy to remember with Memolink")
            .foregroundStyle(.white)
            .customFont(weight: .semiBold, size: 28)
            
          Text("Pictures, emotions, moments — all for you")
            .foregroundStyle(.neutral300)
            .customFont(weight: .regular, size: 18)
        }
        .lineLimit(2)
        .multilineTextAlignment(.leading)
        
        VStack(spacing: 12) {
          PrimaryActionButton(
            title: "Sign Up",
            color: true,
            isEnabled: true,
            isLoading: false
          ) { router.navigate(to: .phoneNumber) }
          
          PrimaryActionButton(
            title: "Sign In",
            color: false,
            isEnabled: true,
            isLoading: false
          ) { router.navigate(to: .login)}
        }
      }
      .padding(.horizontal, 16)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .animation(.easeInOut, value: showSelectLocale)
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
      .padding(.vertical, 8)
      .padding(.leading, 16)
      .padding(.trailing, 8)
      .offset(x: -8)
      .foregroundStyle(.white)
      .background(.thinMaterial)
      .clipShape(Capsule())
      .padding(.trailing, 16)
    }
  }
}

#Preview {
  OnboardingView()
    .environment(OnboardingCoordinator(coordinator: AppCoordinator()))
}
