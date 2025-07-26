//
//  SceneDelegate.swift
//  StryVr
//
//  🌐 Manages App Window & Session Routing
//

import OSLog
import SwiftUI
import UIKit

#if canImport(FirebaseAuth)
    import FirebaseAuth
#endif
#if canImport(FirebaseCore)
    import FirebaseCore
#endif

private let logger = Logger(subsystem: "com.stryvr.app", category: "SceneDelegate")

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            logger.error("❌ Failed to cast scene to UIWindowScene")
            return
        }

        // ✅ Initialize Firebase if not already done
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            logger.info("🔥 Firebase configured in SceneDelegate")
        }

        // ✅ Determine initial view
        let contentView: some View =
            Auth.auth().currentUser != nil
            ? AnyView(HomeView())
            : AnyView(LoginView())

        // ✅ Setup UIWindow with SwiftUI
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()

        logger.info("✅ UIWindow attached to root view")
    }

    func sceneDidBecomeActive(_: UIScene) {
        logger.info("🔄 Scene became active")
    }

    func sceneWillResignActive(_: UIScene) {
        logger.info("⏸️ Scene will resign active")
    }

    func sceneDidEnterBackground(_: UIScene) {
        saveAppState()
    }

    func sceneWillEnterForeground(_: UIScene) {
        checkUserSession()
    }

    // MARK: - Session Management

    private func saveAppState() {
        logger.info("💾 Saving app state")
        // Placeholder: persist user or app data here
    }

    private func checkUserSession() {
        guard let window = window else { return }

        if Auth.auth().currentUser == nil {
            logger.info("🔐 No active user session. Redirecting to LoginView.")
            DispatchQueue.main.async {
                window.rootViewController = UIHostingController(rootView: LoginView())
            }
        }
    }
}
