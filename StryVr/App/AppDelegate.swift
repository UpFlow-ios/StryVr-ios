import UIKit
import Firebase
import UserNotifications
import os

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppDelegate")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        configureFirebase()
        setupPushNotifications(application)
        Messaging.messaging().delegate = self

        return true
    }

    // MARK: - Firebase Configuration
    private func configureFirebase() {
        guard FirebaseApp.app() == nil else {
            logger.info("✅ Firebase already configured.")
            return
        }
        FirebaseApp.configure()
        logger.info("🔥 Firebase configured successfully")
    }

    // MARK: - Push Notification Setup
    private func setupPushNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.logger.info("✅ Push Notifications: Permission granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                self.logger.error("⚠️ Push Notification Error: \(error.localizedDescription)")
            } else {
                self.logger.warning("⚠️ Push Notifications: Permission denied")
            }
        }
    }

    // MARK: - APNS Token Registration
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("📲 APNS Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        logger.error("❌ Push Notification Registration Failed: \(error.localizedDescription)")
    }

    // MARK: - Foreground Notification Handling
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        logger.info("📩 Foreground Notification: \(notification.request.content.userInfo)")
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - Notification Interaction
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        logger.info("🛎️ User Tapped Notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    // MARK: - Firebase Messaging Delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            logger.warning("⚠️ FCM token was nil")
            return
        }
        logger.info("🔄 FCM Registration Token: \(token)")
        sendTokenToServer(token)
    }

    // MARK: - Token Network Upload
    private func sendTokenToServer(_ token: String) {
        guard let url = URL(string: "https://yourserver.com/api/registerToken") else {
            logger.error("❌ Invalid server URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logger.error("❌ Failed to send token to server: \(error.localizedDescription)")
            } else {
                self.logger.info("✅ Token successfully sent to server")
            }
        }
        task.resume()
    }
}
