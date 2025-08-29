import SwiftUI

struct MainView: View {
  var coordinator: AppCoordinator
  
  var body: some View {
    VStack {
      Text("Main View")
      Button("Log out") {
        coordinator.userDidLogout()
      }
    }
  }
}

#Preview {
  MainView(coordinator: AppCoordinator())
}
