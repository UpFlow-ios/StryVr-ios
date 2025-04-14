import UIKit
import Firebase
import UserNotifications
import os.log

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // ✅ Initialize Firebase
        do {
            try FirebaseApp.configure()
            os_log("🔥 Firebase Initialized Successfully", log: .default, type: .info)
        } catch {
            os_log("❌ Firebase Initialization Error: %{public}@", log: .default, type: .error, error.localizedDescription)
            // Handle fallback logic if needed
        }

        // ✅ Push Notification Setup
        setupPushNotifications(application)
        Messaging.messaging().delegate = self

        return true
    }

    // MARK: - Push Notification Setup
    private func setupPushNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                os_log("✅ Push Notifications: Permission granted", log: .default, type: .info)
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                if let error = error {
                    os_log("⚠️ Push Notification Error: %{public}@", log: .default, type: .error, error.localizedDescription)
                } else {
                    os_log("⚠️ Push Notifications: Permission denied", log: .default, type: .error)
                }
            }
        }
    }

    // MARK: - APNS Token Registration
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        os_log("📲 APNS Device Token: %{public}@", log: .default, type: .info, tokenString)

        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        os_log("❌ Push Notification Registration Failed: %{public}@", log: .default, type: .error, error.localizedDescription)
    }

    // MARK: - Foreground Notification Handling
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        os_log("📩 Foreground Notification: %{public}@", log: .default, type: .info, notification.request.content.userInfo)
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - Notification Interaction
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        os_log("🛎️ User Tapped Notification: %{public}@", log: .default, type: .info, response.notification.request.content.userInfo)
        completionHandler()
    }

    // MARK: - Firebase Messaging Delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            os_log("⚠️ FCM token was nil", log: .default, type: .error)
            return
        }
        os_log("🔄 FCM Registration Token: %{public}@", log: .default, type: .info, token)
        sendTokenToServer(token)
    }

    private func sendTokenToServer(_ token: String) {
        // Example implementation for sending the token to your server
        let url = URL(string: "https://yourserver.com/api/registerToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                os_log("❌ Failed to send token to server: %{public}@", log: .default, type: .error, error.localizedDescription)
                return
            }
            os_log("✅ Token successfully sent to server", log: .default, type: .info)
        }
        task.resume()
    }
}
