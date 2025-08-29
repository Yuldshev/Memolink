import SwiftUI

struct ErrorToast: View {
  let message: String
  let onDismiss: () -> Void
  
  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: "exclamationmark.circle.fill")
        .foregroundStyle(.white)
        .font(.system(size: 28))
      
      VStack(alignment: .leading, spacing: 4.0) {
        Text("Error")
          .customFont(weight: .semiBold, size: 20)
        
        Text(message)
          .customFont(weight: .regular, size: 15)
          .multilineTextAlignment(.leading)
      }
      .foregroundStyle(.white)
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.red)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .padding(.horizontal, 16)
  }
}

#Preview {
  ErrorToast(message: "Please enter valid phone number and password") {}
    .frame(maxHeight: .infinity, alignment: .top)
}
