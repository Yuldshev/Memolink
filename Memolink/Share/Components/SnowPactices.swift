import SwiftUI

struct SnowPactices: View {
  let intensity: SnowIntensity
  
  @State private var particles: [SnowParticle] = []
  @State private var timer: Timer?
  
  enum SnowIntensity {
    case light, medium, heavy
    
    var particleCount: Int {
      switch self {
      case .light:
          return 20
      case .medium:
          return 50
      case .heavy:
          return 100
      }
    }
  }
  
  var body: some View {
    Canvas { context, _ in
      for particle in particles {
        context.opacity = particle.opacity
        context.fill(
          Path(ellipseIn: CGRect(
            x: particle.x,
            y: particle.y,
            width: particle.size,
            height: particle.size
          )),
          with: .color(.white)
        )
      }
    }
    .onAppear { startSnowfall() }
    .onDisappear { timer?.invalidate() }
  }
  
  private func startSnowfall() {
    // Initialize particles
    particles = (0..<intensity.particleCount).map { _ in
      SnowParticle(
        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
        y: CGFloat.random(in: -100...0),
        size: CGFloat.random(in: 2...5),
        speed: CGFloat.random(in: 1...3),
        opacity: Double.random(in: 0.3...1.0)
      )
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
      updateParticles()
    }
  }
  
  private func updateParticles() {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    for index in particles.indices {
      particles[index].y += particles[index].speed
      
      if particles[index].y > screenHeight {
        particles[index].y = -10
        particles[index].x = CGFloat.random(in: 0...screenWidth)
      }
    }
  }
}

struct SnowParticle {
  var x: CGFloat
  var y: CGFloat
  let size: CGFloat
  let speed: CGFloat
  let opacity: Double
}

#Preview {
  ZStack {
    Color.black
    SnowPactices(intensity: .light)
  }
  .ignoresSafeArea()
}
