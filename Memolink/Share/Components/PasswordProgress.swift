import SwiftUI

struct PasswordProgress: View {
  var count: Int
  
  var body: some View {
    HStack(spacing: 4) {
      ForEach(0..<3, id: \.self) { index in
        Capsule()
          .frame(height: 2)
          .foregroundStyle(index < strengthLevel.progress ? strengthLevel.color : .black200)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: count)
  }
  
  private var strengthLevel: (progress: Int, color: Color) {
    switch count {
    case 0...4:
        return (1, .red)
    case 5...8:
        return (2, .yellow)
    case 9...:
        return (3, .green)
    default:
        return (0, .black200)
    }
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    
    PasswordProgress(count: 5)
      .padding()
  }
}
