import SwiftUI

struct Toast: View {
  let toastType: ToastType
  let message: LocalizedStringKey
  let onDismiss: () -> Void
  
  var body: some View {
    HStack(spacing: 16) {
      Image("icon_\(toastType.rawValue)")
        .resizable()
        .scaledToFill()
        .frame(width: 32, height: 32)
        .shadow(color: toastType.color, radius: 12, x: 0, y: 2)
      
      Text(message)
        .customFont(weight: .regular, size: 16)
        .foregroundStyle(.white)
        .multilineTextAlignment(.leading)
    }
    .padding(12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.black800)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay {
      RoundedRectangle(cornerRadius: 16)
        .stroke(gradient, lineWidth: 1)
    }
    .padding(.horizontal, 16)
  }
  
  private var gradient: LinearGradient {
    LinearGradient(
      colors: [.neutral600, .clear],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}

// MARK: - Toast type
enum ToastType: String {
  case success
  case info
  case warning
  case error
  
  var color: Color {
    switch self {
    case .success:
      return .appGreen
    case .info:
      return .appBlue
    case .warning:
      return .appYellow
    case .error:
      return .appRed
    }
  }
}
// MARK: - Preview
#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    VStack {
      Toast(toastType: .success, message: "Success register") {}
      Toast(toastType: .error, message: "Please try again later") {}
    }
    .frame(maxHeight: .infinity, alignment: .top)
  }
}
