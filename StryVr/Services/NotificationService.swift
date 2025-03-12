//
//  NotificationService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import UserNotifications
import FirebaseMessaging
import os.log

/// Handles push notifications for security alerts, mentor updates, and learning progress
final class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate, MessagingDelegate {

    static let shared = NotificationService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "NotificationService")

    private override init() {}

    /// Requests push notification permissions from the user
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                self.logger.error("Notification Permission Error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    /// Handles receiving push notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    /// Handles user interactions with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        self.logger.info("User tapped on a notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    /// Configures Firebase Messaging for push notifications
    func configureFirebaseMessaging() {
        Messaging.messaging().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }

    /// Handles updating the Firebase FCM token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        self.logger.info("Firebase FCM Token: \(token)")
        saveDeviceTokenToDatabase(token)
    }

    /// Stores the FCM device token in Firestore for targeted notifications
    private func saveDeviceTokenToDatabase(_ token: String) {
        guard let userID = AuthService.shared.getCurrentUser()?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userID).updateData(["deviceToken": token]) { error in
            if let error = error {
                self.logger.error("Error saving device token: \(error.localizedDescription)")
            } else {
                self.logger.info("Device token saved successfully")
            }
        }
    }

    /// Sends a test notification (for debugging)
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test push notification from StryVr."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.logger.error("Error scheduling test notification: \(error.localizedDescription)")
            } else {
                self.logger.info("Test notification scheduled successfully")
            }
        }
    }
}
