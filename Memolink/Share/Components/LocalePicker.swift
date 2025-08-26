import SwiftUI

struct LocalePicker: View {
  let item: LocaleApp
  @Binding var select: LocaleApp

  private var isSelected: Bool { item == select }

  var body: some View {
    HStack(spacing: 0) {
      HStack(spacing: 8) {
        Image(item.icon)
          .frame(width: 24, height: 24)

        Text(item.title)
          .foregroundStyle(.white)
          .customFont(weight: .medium, size: 16)
      }

      Spacer()

      selectionIndicator
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
    .background(.black700)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay(selectedBorder)
    .contentShape(Rectangle())
    .onTapGesture { select = item }
    .animation(.smooth(duration: 0.2), value: isSelected)
  }

  private var selectionIndicator: some View {
    Circle()
      .stroke(isSelected ? .primary500 : .neutral600, lineWidth: 2)
      .frame(width: 20, height: 20)
      .overlay {
        if isSelected {
          Circle()
            .fill(.primary500)
            .frame(width: 8, height: 8)
            .transition(.scale.combined(with: .opacity))
        }
      }
  }

  private var selectedBorder: some View {
    RoundedRectangle(cornerRadius: 16)
      .stroke(isSelected ? .primary500 : .clear, lineWidth: 2)
  }
}

// MARK: - LocaleApp
enum LocaleApp: String, CaseIterable, Identifiable {
  case en, ru, uz

  var id: String { rawValue }

  var icon: String {
    "flag_\(rawValue)"
  }

  var title: LocalizedStringKey {
    switch self {
    case .en: 
        return "English"
    case .ru: 
        return "Русский"
    case .uz: 
        return "O'zbekcha"
    }
  }

  var locale: Locale {
    Locale(identifier: rawValue)
  }

  var displayName: String {
    locale.localizedString(forIdentifier: rawValue) ?? title.stringValue
  }
}

extension LocalizedStringKey {
  var stringValue: String {
    String(describing: self)
  }
}
// MARK: - Preview
#Preview {
  @Previewable @State var selectLocale: LocaleApp = .en

  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      LocalePicker(item: .en, select: $selectLocale)
      LocalePicker(item: .ru, select: $selectLocale)
      LocalePicker(item: .uz, select: $selectLocale)
    }
    .padding()
  }
}
