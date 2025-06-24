//
//  AppDelegate.swift
//  StryVr
//
//  🔒 Secure App Lifecycle Setup with Firebase & Push Notifications
//

import Firebase
import os
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    private let logger = Logger(subsystem: "com.stryvr.app", category: "AppDelegate")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
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
                self.logger.error("❌ Push Notification Error: \(error.localizedDescription)")
            } else {
                self.logger.warning("⚠️ Push Notifications: Permission denied by user.")
            }
        }
    }

    // MARK: - APNS Token Registration

    func application(
        _: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("📲 APNS Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        logger.error("❌ Failed to register for APNS: \(error.localizedDescription)")
    }

    // MARK: - Firebase Messaging Delegate

    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            logger.warning("⚠️ FCM token was nil.")
            return
        }
        logger.info("🔄 FCM Registration Token: \(token)")
        sendTokenToServer(token)
    }

    // MARK: - Upload Token to Server

    private func sendTokenToServer(_ token: String) {
        guard let url = URL(string: "https://yourserver.com/api/registerToken") else {
            logger.error("❌ Invalid token registration URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                self.logger.error("❌ Failed to send token: \(error.localizedDescription)")
            } else {
                self.logger.info("✅ Token sent to server successfully.")
            }
        }
        task.resume()
    }

    // MARK: - Foreground Notification Handler

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        logger.info("📩 Received notification in foreground: \(notification.request.content.userInfo)")
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - Notification Interaction Handler

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        logger.info("🛎️ User interacted with notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
