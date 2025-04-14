import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseCore
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            os_log("❌ Failed to cast scene to UIWindowScene", log: .default, type: .error)
            return
        }

        // ✅ Configure Firebase only if not already configured
        if FirebaseApp.app() == nil {
            do {
                FirebaseApp.configure()
                os_log("🔥 Firebase configured in SceneDelegate", log: .default, type: .info)
            } catch {
                os_log("❌ Firebase configuration failed: %{public}@", log: .default, type: .error, error.localizedDescription)
                return
            }
        }

        // ✅ Select root view based on authentication state
        let contentView: some View = Group {
            if Auth.auth().currentUser != nil {
                HomeView()
            } else {
                LoginView()
            }
        }

        // ✅ Apply SwiftUI view to UIWindow
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()

        os_log("✅ UIWindow attached to root view", log: .default, type: .info)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        os_log("🔄 Scene became active", log: .default, type: .info)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        os_log("⏸️ Scene will resign active", log: .default, type: .info)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveAppState()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        checkUserSession()
    }

    // MARK: - Session Management
    private func saveAppState() {
        os_log("💾 Saving app state", log: .default, type: .info)
        // Placeholder for state saving logic
        // Example: Save user preferences or app data
    }

    private func checkUserSession() {
        if Auth.auth().currentUser == nil {
            os_log("🔐 No active user session. Redirecting to LoginView.", log: .default, type: .info)
            DispatchQueue.main.async {
                self.window?.rootViewController = UIHostingController(rootView: LoginView())
            }
        }
    }
}
