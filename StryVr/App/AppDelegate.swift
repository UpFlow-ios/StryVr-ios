import UIKit
import Firebase
import UserNotifications
import os.log

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Initialize Firebase with error handling
        do {
            try FirebaseApp.configure()
            os_log("🔥 Firebase Initialized Successfully", log: .default, type: .info)
        } catch let error {
            os_log("❌ Firebase Initialization Error: %{public}@", log: .default, type: .error, error.localizedDescription)
        }

        // Set up push notifications
        setupPushNotifications(application)

        // Set Firebase Messaging delegate
        return true
    }

    // MARK: - Push Notifications
    func Messaging;.messaging().delegate = self

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
                    os_log("⚠️ Push Notifications: Permission denied with error: %{public}@", log: .default, type: .error, error.localizedDescription)
                } else {
                    os_log("⚠️ Push Notifications: Permission denied", log: .default, type: .error)
                }
            }
        }
    }

    // Called when device successfully registers for push notifications
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        os_log("📲 APNS Device Token: %{public}@", log: .default, type: .info, tokenString)

        // Register token with Firebase for messaging
        FirebaseMessaging.Messaging.messaging().apnsToken = deviceToken
    }

    // Called when push notification registration fails
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        os_log("❌ Failed to register for push notifications: %{public}@", log: .default, type: .error, error.localizedDescription)
    }
}

// MARK: - UNUserNotificationCenterDelegate (Handles Notifications in Foreground)
extension AppDelegate: UNUserNotificationCenterDelegate {

    // Handle notification while app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        os_log("📩 Received Notification: %{public}@", log: .default, type: .info, notification.request.content.userInfo)
        completionHandler([.banner, .sound, .badge]) // Show notification as banner
    }

    // Handle user's tap on notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        os_log("🛎️ User interacted with notification: %{public}@", log: .default, type: .info, response.notification.request.content.userInfo)
        completionHandler()
    }
}

// MARK: - MessagingDelegate (Handles Firebase Messaging)
extension AppDelegate: MessagingDelegate {

    // Handle Firebase messaging token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        os_log("🔄 Firebase registration token: %{public}@", log: .default, type: .info, String(describing: fcmToken))
        if let token = fcmToken {
            sendTokenToServer(token)
        }
    }

    // Send the token to the application server
    private func sendTokenToServer(_ token: String) {
        // TODO: Implement the logic to send the token to your server
        os_log("📡 Sending token to server: %{public}@", log: .default, type: .info, token)
    }
}

