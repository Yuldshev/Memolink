import SwiftUI

struct ChooseLocale: View {
  var router: OnboardingCoordinator
  @State private var selectedLocale: LocaleApp
  @Environment(\.dismiss) var dismiss
  
  init(router: OnboardingCoordinator) {
    self.router = router
    let currentLocale = router.coordinator.locale
    self._selectedLocale = State(wrappedValue: currentLocale)
  }

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 16) {
        Text("Choose language")
          .foregroundStyle(.white)
          .customFont(weight: .semiBold, size: 24)

        VStack(spacing: 8) {
          ForEach(LocaleApp.allCases) { index in
            LocalePicker(item: index, select: $selectedLocale)
          }
        }
        .padding(.bottom, 16)

        PrimaryActionButton(
          title: "Apply",
          isLoading: false
        ) {
          router.coordinator.changeLocale(selectedLocale)
          dismiss()
        }
      }
      .padding(.top, 32)
      .padding(.horizontal, 16)
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }
}

#Preview {
  @Previewable @State var locale: LocaleApp = .en
  ChooseLocale(router: OnboardingCoordinator(coordinator: AppCoordinator()))
}
