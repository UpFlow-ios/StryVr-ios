//
//  SceneDelegate.swift
//  StryVr
//
//  🌐 Manages App Window & Session Routing
//

import OSLog
import SwiftUI
import UIKit

private let logger = Logger(subsystem: "com.stryvr.app", category: "SceneDelegate")

#if !DEBUG_TESTING
    import FirebaseCore
    import FirebaseAuth
#endif

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            logger.error("❌ Failed to cast scene to UIWindowScene")
            return
        }

        // ✅ Initialize Firebase only outside test context
        #if !DEBUG_TESTING
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
                logger.info("🔥 Firebase configured in SceneDelegate")
            }
        #endif

        // ✅ Determine initial view
        let contentView: some View = {
            #if !DEBUG_TESTING
                return Auth.auth().currentUser != nil
                    ? AnyView(HomeView())
                    : AnyView(LoginView())
            #else
                return AnyView(Text("🧪 Running UI Tests"))
            #endif
        }()

        // ✅ Setup UIWindow with SwiftUI
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()

        logger.info("✅ UIWindow attached to root view")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        logger.info("🔄 Scene became active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        logger.info("⏸️ Scene will resign active")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveAppState()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        checkUserSession()
    }

    // MARK: - Session Management

    private func saveAppState() {
        logger.info("💾 Saving app state")
        // App state persistence handled by Firebase Auth and UserDefaults
    }

    private func checkUserSession() {
        guard let window = window else { return }

        #if !DEBUG_TESTING
            if Auth.auth().currentUser == nil {
                logger.info("🔐 No active user session. Redirecting to LoginView.")
                DispatchQueue.main.async {
                    window.rootViewController = UIHostingController(rootView: LoginView())
                }
            }
        #endif
    }
}
