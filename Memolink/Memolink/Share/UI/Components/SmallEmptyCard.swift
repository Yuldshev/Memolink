import SwiftUI

struct SmallEmptyCard: View {
  var selectedItem: Item = .album

  var body: some View {
    ZStack {
      Image(selectedItem.icon)
        .foregroundStyle(.white)
    }
    .padding(.vertical, 24)
    .padding(.horizontal, 20)
    .background(.appDarkGray)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(.accent, lineWidth: 4)
    }
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .rotationEffect(.degrees(selectedItem.degrees))
  }
}

// MARK: - Enum Items
extension SmallEmptyCard {
  enum Item: String {
    case album, text, calendar, playlist

    var icon: String {
      switch self {
      case .album: return "icon_album"
      case .text: return "icon_text"
      case .calendar: return "icon_calendar"
      case .playlist: return "icon_playlist"
      }
    }

    var degrees: Double {
      switch self {
      case .album: return 2.5
      case .text: return 11
      case .calendar: return -10.5
      case .playlist: return 4
      }
    }
  }
}

// MARK: - Preview
#Preview {
  ZStack {
    Color.black.ignoresSafeArea()

    HStack {
      SmallEmptyCard(selectedItem: .album)
      SmallEmptyCard(selectedItem: .calendar)
      SmallEmptyCard(selectedItem: .playlist)
      SmallEmptyCard(selectedItem: .text)
    }
  }
}
