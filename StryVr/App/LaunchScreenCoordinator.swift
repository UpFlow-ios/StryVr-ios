xzhjsjsajjssdsissaimport SwiftUI

class LaunchScreenCoordinator: ObservableObject {
    @Published var showLaunchScreen = true
    @Published var animationComplete = false
    
    private let animationDuration: TimeInterval = 4.5
    
    func startLaunchAnimation() {
        // Reset state
        showLaunchScreen = true
        animationComplete = false
        
        // Wait for animation to complete, then transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.animationComplete = true
            }
            
            // Hide launch screen after fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showLaunchScreen = false
            }
        }
    }
}

struct LaunchScreenContainerView: View {
    @StateObject private var coordinator = LaunchScreenCoordinator()
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            if coordinator.showLaunchScreen {
                StryVrLaunchScreenView()
                    .opacity(coordinator.animationComplete ? 0 : 1)
                    .transition(.opacity)
                    .onAppear {
                        coordinator.startLaunchAnimation()
                    }
            } else {
                // Your main app content here
                MainAppView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: coordinator.showLaunchScreen)
    }
}

// Placeholder for your main app view
struct MainAppView: View {
    var body: some View {
        Text("StryVr Main App")
            .font(.largeTitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}

#Preview {
    LaunchScreenContainerView()
} 
