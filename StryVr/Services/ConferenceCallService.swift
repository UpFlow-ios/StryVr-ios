//
//  ConferenceCallService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import AVFoundation
import FirebaseFirestore
import Foundation
import OSLog

/// Manages real-time video calls, recording, chat, and screen sharing
final class ConferenceCallService {
    static let shared = ConferenceCallService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "ConferenceCallService")

    private init() {}

    // MARK: - Schedule Call

    /// Schedules a new conference call
    func scheduleConferenceCall(title: String, hostID: String, scheduledDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        guard !title.isEmpty, !hostID.isEmpty else {
            logger.error("❌ Invalid input for scheduling call")
            completion(false, ConferenceCallError.invalidInput)
            return
        }

        let callID = UUID().uuidString
        let callData: [String: Any] = [
            "title": title,
            "hostID": hostID,
            "id": callID,
            "participants": [hostID],
            "scheduledDate": scheduledDate,
            "status": "upcoming",
            "chatMessages": [],
            "recordingURL": "",
            "screenSharingEnabled": false,
        ]

        db.collection("conferenceCalls").document(callID).setData(callData) { error in
            if let error = error {
                self.logger.error("❌ Error scheduling call: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("✅ Call scheduled: \(title)")
                completion(true, nil)
            }
        }
    }

    // MARK: - Update Status

    /// Updates the status of a conference call
    func updateCallStatus(callID: String, status: String, completion: @escaping (Bool, Error?) -> Void) {
        guard !callID.isEmpty, !status.isEmpty else {
            logger.error("❌ Invalid input for updating call status")
            completion(false, ConferenceCallError.invalidInput)
            return
        }

        db.collection("conferenceCalls").document(callID).updateData([
            "status": status,
        ]) { error in
            if let error = error {
                self.logger.error("❌ Error updating status: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("🔄 Status updated to: \(status)")
                completion(true, nil)
            }
        }
    }

    // MARK: - Screen Sharing

    /// Enables or disables screen sharing for a conference call
    func enableScreenSharing(callID: String, isEnabled: Bool, completion: @escaping (Bool, Error?) -> Void) {
        guard !callID.isEmpty else {
            logger.error("❌ Invalid input for screen sharing")
            completion(false, ConferenceCallError.invalidInput)
            return
        }

        db.collection("conferenceCalls").document(callID).updateData([
            "screenSharingEnabled": isEnabled,
        ]) { error in
            if let error = error {
                self.logger.error("❌ Screen sharing update error: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("🖥️ Screen sharing \(isEnabled ? "enabled" : "disabled")")
                completion(true, nil)
            }
        }
    }

    // MARK: - Add Chat Message

    /// Adds a chat message to a conference call
    func addChatMessage(callID: String, senderID: String, message: String, timestamp: Date, completion: @escaping (Bool, Error?) -> Void) {
        guard !callID.isEmpty, !senderID.isEmpty, !message.isEmpty else {
            logger.error("❌ Invalid input for adding chat message")
            completion(false, ConferenceCallError.invalidInput)
            return
        }

        let messageData: [String: Any] = [
            "senderID": senderID,
            "message": message,
            "timestamp": timestamp,
        ]

        db.collection("conferenceCalls").document(callID).updateData([
            "chatMessages": FieldValue.arrayUnion([messageData]),
        ]) { error in
            if let error = error {
                self.logger.error("❌ Chat message failed: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("💬 Chat message added for call \(callID)")
                completion(true, nil)
            }
        }
    }
}

// MARK: - Custom Error Type

enum ConferenceCallError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided."
        }
    }
}
