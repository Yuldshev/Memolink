import SwiftUI

struct MainView: View {
  var coordinator: AppCoordinator
  
  var body: some View {
    VStack {
      Text("Main View")
      Button("Sign out") {
        coordinator.userDidLogout()
      }
    }
  }
}

#Preview {
  MainView(coordinator: AppCoordinator())
}
