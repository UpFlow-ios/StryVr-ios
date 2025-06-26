//
//  SceneDelegate.swift
//  StryVr
//
//  🌐 Manages App Window & Session Routing
//

import SwiftUI
import UIKit
import os.log

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
            os_log("❌ Failed to cast scene to UIWindowScene", log: .default, type: .error)
            return
        }

        // ✅ Initialize Firebase only outside test context
        #if !DEBUG_TESTING
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            os_log("🔥 Firebase configured in SceneDelegate", log: .default, type: .info)
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
        // TODO: persist user or app data here
    }

    private func checkUserSession() {
        guard let window = window else { return }

        #if !DEBUG_TESTING
        if Auth.auth().currentUser == nil {
            os_log("🔐 No active user session. Redirecting to LoginView.", log: .default, type: .info)
            DispatchQueue.main.async {
                window.rootViewController = UIHostingController(rootView: LoginView())
            }
        }
        #endif
    }
}
