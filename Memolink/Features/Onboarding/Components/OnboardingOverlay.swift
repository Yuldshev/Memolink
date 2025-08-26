import SwiftUI

struct OnboardingOverlay: View {
  @State private var animatingIndex = 0
  @State private var timer: Timer?
  @State private var offsetY: CGFloat = -50
  @State private var toggle = false

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      LazyVGrid(columns: Array(repeating: GridItem(.fixed(80)), count: 3), spacing: 48) {
        ForEach(0..<9, id: \.self) { index in
          Image("img_\(index + 1)")
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .scaleEffect(index == animatingIndex ? 0.8 : 1)
        }
      }
      .scaleEffect(2.4)
      .rotationEffect(.degrees(24))
      .offset(x: -30, y: offsetY)

      LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    .onAppear {
      timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
        withAnimation(.easeInOut(duration: 0.8)) {
          animatingIndex = (animatingIndex + 1) % 9
          toggle.toggle()
          offsetY = toggle ? -50 : -100
        }
      }
    }
    .onDisappear {
      timer?.invalidate()
    }
  }
}

#Preview {
  OnboardingOverlay()
}
