import SwiftUI

struct ChooseLocale: View {
  @Binding var locale: LocaleApp
  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 16) {
        Text("Choose language")
          .foregroundStyle(.white)
          .customFont(weight: .semiBold, size: 24)

        VStack(spacing: 8) {
          ForEach(LocaleApp.allCases) { index in
            LocalePicker(item: index, select: $locale)
          }
        }
        .padding(.bottom, 16)

        PrimaryActionButton(
          title: "Apply",
          color: true,
          isEnabled: true,
          isLoading: false
        ) { dismiss() }
      }
      .padding(.top, 32)
      .padding(.horizontal, 16)
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }
}

#Preview {
  @Previewable @State var locale: LocaleApp = .en
  ChooseLocale(locale: $locale)
}
