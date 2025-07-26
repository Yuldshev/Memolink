import SwiftUI

struct SelectLanguage: View {
  var selectedLanguage: Item = .english
  var isSelected: Bool = false

  var body: some View {
    HStack {
      Image(selectedLanguage.icon)

      Text(selectedLanguage.rawValue)
        .foregroundStyle(.white)
        .customFont(weight: .medium, size: .size16)

      Spacer()

      Circle()
        .stroke(isSelected ? .accent : .white.opacity(0.4), lineWidth: isSelected ? 6 : 1)
        .frame(width: 16, height: 16)
    }
    .padding(.horizontal, 16)
    .frame(height: 56)
    .background(.appGray)
    .overlay {
      if isSelected {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(.accent, lineWidth: 2)
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

// MARK: - Enum Item
extension SelectLanguage {
  enum Item: String {
    case english = "English"
    case russia = "Русский"
    case uzbek = "O'zbekcha"

    var icon: String {
      switch self {
      case .english: return "icon_us"
      case .russia: return "icon_ru"
      case .uzbek: return "icon_uz"
      }
    }
  }
}
// MARK: - Preview
#Preview {
  ZStack {
    Color.black.ignoresSafeArea()

    VStack {
      SelectLanguage(selectedLanguage: .english, isSelected: true)
      SelectLanguage(selectedLanguage: .russia)
      SelectLanguage(selectedLanguage: .uzbek)
    }
  }
}
