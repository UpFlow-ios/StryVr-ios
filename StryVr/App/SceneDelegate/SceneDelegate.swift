import UIKit
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize UIWindow
        window = UIWindow(windowScene: windowScene)
        
        // Configure Firebase (Ensures it's properly set up)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Check Authentication State
        let rootViewController: UIViewController
        if Auth.auth().currentUser != nil {
            // User is signed in, navigate to main app
            rootViewController = MainTabBarController() // Replace with your main app entry point
        } else {
            // User is not signed in, navigate to login screen
            rootViewController = LoginViewController() // Replace with your authentication screen
        }
        
        // Set root view controller
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // App became active - Resume tasks
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // App will become inactive (e.g., phone call)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // App moved to background
        saveAppState()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // App will enter foreground
        checkUserSession()
    }

    private func saveAppState() {
        // Save necessary app state for smooth background transitions
    }

    private func checkUserSession() {
        // Check if user session is still valid
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
            }
        }
    }
}
