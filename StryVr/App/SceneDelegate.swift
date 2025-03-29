import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Configure Firebase if not already configured
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Set initial view based on authentication state
        let contentView: some View = Group {
            if Auth.auth().currentUser != nil {
                HomeView() // replace with your actual initial SwiftUI view after login
            } else {
                LoginView() // replace with your actual SwiftUI login view
            }
        }

        // Initialize the UIWindow with SwiftUI HostingController
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // App became active - Resume tasks
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // App will become inactive (e.g., phone call)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveAppState()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        checkUserSession()
    }

    private func saveAppState() {
        // Implement state saving if needed
    }

    private func checkUserSession() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.window?.rootViewController = UIHostingController(rootView: LoginView())
            }
        }
    }
}
