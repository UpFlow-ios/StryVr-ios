import SwiftUI
import Firebase
import os.log

@main
struct StryVrApp: App {

    // ✅ Integrate AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // ✅ Global Auth Model
    @StateObject private var authViewModel = AuthViewModel.shared

    init() {
        // ✅ Firebase Initialization
        if FirebaseApp.app() == nil {
            do {
                FirebaseApp.configure()
                os_log("🔥 Firebase configured successfully", log: .default, type: .info)
            } catch {
                os_log("❌ Firebase configuration failed: %{public}@", log: .default, type: .error, error.localizedDescription)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.userSession != nil {
                    HomeView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
        }
    }
}
