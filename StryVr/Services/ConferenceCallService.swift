//
//  ConferenceCallService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// Manages real-time video calls, recording, chat, and screen sharing
final class ConferenceCallService {

    static let shared = ConferenceCallService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ConferenceCallService")

    private init() {}

    /// Schedules a new conference call
    /// - Parameters:
    ///   - title: The title of the conference call.
    ///   - hostID: The ID of the host.
    ///   - scheduledDate: The date and time the call is scheduled for.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func scheduleConferenceCall(title: String, hostID: String, scheduledDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        let callID = UUID().uuidString
        let callData: [String: Any] = [
            "id": callID,
            "title": title,
            "hostID": hostID,
            "participants": [hostID],
            "scheduledDate": scheduledDate,
            "status": "upcoming",
            "chatMessages": [],
            "recordingURL": "",
            "screenSharingEnabled": false
        ]

        db.collection("conferenceCalls").document(callID).setData(callData) { error in
            if let error = error {
                self.logger.error("Error scheduling conference call: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("Conference call scheduled successfully")
                completion(true, nil)
            }
        }
    }

    /// Updates the status of a conference call (Live, Ongoing, Ended)
    /// - Parameters:
    ///   - callID: The ID of the conference call.
    ///   - status: The new status of the call.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func updateCallStatus(callID: String, status: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("conferenceCalls").document(callID).updateData([
            "status": status
        ]) { error in
            if let error = error {
                self.logger.error("Error updating call status: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("Conference call status updated to \(status)")
                completion(true, nil)
            }
        }
    }

    /// Enables screen sharing during a live session
    /// - Parameters:
    ///   - callID: The ID of the conference call.
    ///   - isEnabled: A boolean indicating whether screen sharing is enabled.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func enableScreenSharing(callID: String, isEnabled: Bool, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("conferenceCalls").document(callID).updateData([
            "screenSharingEnabled": isEnabled
        ]) { error in
            if let error = error {
                self.logger.error("Error updating screen sharing status: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("Screen sharing \(isEnabled ? "enabled" : "disabled")")
                completion(true, nil)
            }
        }
    }

    /// Stores a chat message in Firestore for a specific conference call
    /// - Parameters:
    ///   - callID: The ID of the conference call.
    ///   - senderID: The ID of the sender.
    ///   - message: The chat message.
    ///   - timestamp: The timestamp of the message.
