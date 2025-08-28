import SwiftUI

struct PasswordProgress: View {
  var strength: PasswordStrength
  
  var body: some View {
    HStack(spacing: 4) {
      ForEach(0..<3, id: \.self) { index in
        Capsule()
          .frame(height: 2)
          .foregroundStyle(index < strength.progress ? strength.color : .black200)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: strength.progress)
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    PasswordProgress(strength: PasswordStrength(progress: 4, color: .red))
      .padding()
  }
}
