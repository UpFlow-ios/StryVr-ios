//
//  NotificationServiceProtocol.swift
//  StryVr
//
//  🔔 Notification Service Protocol – Abstracted interface for notification services
//

import Foundation
import UserNotifications

/// Protocol defining notification service operations used in StryVr
protocol NotificationServiceProtocol {
    /// Request notification permissions
    func requestPermissions(completion: @escaping (Bool) -> Void)
    
    /// Schedule local notification
    func scheduleNotification(
        title: String,
        body: String,
        timeInterval: TimeInterval,
        identifier: String,
        completion: @escaping (Bool) -> Void
    )
    
    /// Cancel scheduled notification
    func cancelNotification(identifier: String)
    
    /// Cancel all scheduled notifications
    func cancelAllNotifications()
    
    /// Send push notification to user
    func sendPushNotification(
        to userID: String,
        title: String,
        body: String,
        data: [String: String]?,
        completion: @escaping (Bool) -> Void
    )
    
    /// Get notification settings
    func getNotificationSettings(completion: @escaping (UNNotificationSettings) -> Void)
    
    /// Check if notifications are authorized
    var isAuthorized: Bool { get }
} 