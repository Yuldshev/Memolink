import SwiftUI

struct SplashView: View {
  @State private var isAnimating = false
  @State private var showText = false
  
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      
      VStack(spacing: 24) {
        Image(.iconLogo)
          .resizable()
          .scaledToFill()
          .frame(width: 120, height: 120)
          .foregroundStyle(.primary500)
          .scaleEffect(isAnimating ? 1 : 0.5)
          .opacity(isAnimating ? 1 : 0)
          .animation(.easeOut(duration: 0.8), value: isAnimating)
        
        Group {
          if showText {
            Text("Memolink")
              .customFont(weight: .semiBold, size: 24)
              .foregroundStyle(.white)
          }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
      }
    }
    .onAppear {
      withAnimation { isAnimating = true }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.easeIn(duration: 0.6)) { showText = true }
      }
    }
  }
}

#Preview {
  SplashView()
}
