//
//  NotificationService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import Foundation
import OSLog
import UserNotifications

/// Manages push notifications for video engagement, recommendations, and learning reminders
@MainActor
@preconcurrency
final class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate,
    MessagingDelegate {
    static let shared = NotificationService()
    private let firestore = Firestore.firestore()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "NotificationService")

    override private init() {}

    // MARK: - Notification Permissions

    /// Requests push notification permissions from the user
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self?.registerForRemoteNotifications()
                } else {
                    self?.logger.warning("🔔 Notification permissions denied")
                }
            }
        }
    }

    private func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Handles receiving push notifications while the app is in the foreground
    nonisolated func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
            Void
    ) {
        completionHandler([.banner, .sound])
    }

    /// Handles user interactions with notifications
    nonisolated func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        logger.info("🔔 Notification tapped: \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    // MARK: - Firebase Messaging

    /// Configures Firebase Messaging for push notifications
    func configureFirebaseMessaging() {
        Messaging.messaging().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }

    /// Handles updating the Firebase FCM token
    nonisolated func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        logger.info("📱 Firebase FCM Token received")
        Task { @MainActor in
            saveDeviceTokenToDatabase(token)
        }
    }

    /// Stores the FCM device token in Firestore for targeted notifications
    private func saveDeviceTokenToDatabase(_ token: String) {
        guard let userID = AuthService.shared.getCurrentUser()?.uid else { return }

        firestore.collection("users").document(userID).updateData(["deviceToken": token]) { error in
            if let error = error {
                self.logger.error("❌ Failed to save device token: \(error.localizedDescription)")
            } else {
                self.logger.info("✅ Device token saved successfully")
            }
        }
    }

    // MARK: - Engagement Notifications

    /// Sends a video engagement notification
    func sendVideoEngagementNotification(to userID: String, videoTitle: String, type: String) {
        guard !userID.isEmpty, !videoTitle.isEmpty, !type.isEmpty else {
            logger.error("❌ Invalid input for video engagement notification")
            return
        }

        let message =
            type == "like"
            ? "Someone liked your video: \(videoTitle)"
            : type == "comment"
                ? "Someone commented on your video: \(videoTitle)"
                : "Your video is trending: \(videoTitle)"

        sendPushNotification(to: userID, title: "📢 Video Engagement", body: message)
    }

    // MARK: - Universal Push Sender

    /// Sends a push notification to a specific user
    func sendPushNotification(to userID: String, title: String, body: String) {
        guard !userID.isEmpty, !title.isEmpty, !body.isEmpty else {
            logger.error("❌ Invalid input for push notification")
            return
        }

        firestore.collection("users").document(userID).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.logger.error("❌ Failed to fetch user token: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(),
                let deviceToken = data["deviceToken"] as? String
            else {
                self.logger.warning("⚠️ No device token found for user \(userID)")
                return
            }

            // Prepare and send via Cloud Function, FCM or 3rd-party service
            // 🔒 You may call a Firebase Cloud Function here using HTTPS callable or external API integration
            self.logger.info("📤 Sending push notification")
            // Production: trigger Cloud Function/FCM REST API here
        }
    }
}
