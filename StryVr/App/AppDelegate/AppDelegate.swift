import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // ✅ Initialize Firebase
        FirebaseApp.configure()
        print("🔥 Firebase Initialized Successfully")
        
        // ✅ Set up push notifications
        setupPushNotifications(application)
        
        // ✅ Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // MARK: - Push Notifications
    private func setupPushNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Push Notifications: Permission granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("⚠️ Push Notifications: Permission denied")
            }
        }
    }
    
    // Called when device successfully registers for push notifications
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📲 APNS Device Token: \(tokenString)")
        
        // ✅ Register token with Firebase for messaging
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Called when push notification registration fails
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
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
        print("📩 Received Notification: \(notification.request.content.userInfo)")
        completionHandler([.banner, .sound, .badge]) // Show notification as banner
    }
    
    // Handle user's tap on notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("🛎️ User interacted with notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

// MARK: - MessagingDelegate (Handles Firebase Messaging)
extension AppDelegate: MessagingDelegate {
    
    // Handle Firebase messaging token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔄 Firebase registration token: \(String(describing: fcmToken))")
        // TODO: If necessary, send token to application server.
    }
}
```

This ensures that your app handles Firebase messaging events and responds to changes in notification settings.
