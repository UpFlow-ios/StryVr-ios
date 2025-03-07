import SwiftUI
import Firebase

@main
struct StryVrApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView() // Set HomeView as the default screen
                .environmentObject(AuthViewModel.shared) // Inject authentication state globally
        }
    }
}

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    // Add your authentication logic here
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase with error handling
        do {
            try FirebaseApp.configure()
        } catch let error {
            print("Error configuring Firebase: \(error.localizedDescription)")
        }
        return true
    }
}
