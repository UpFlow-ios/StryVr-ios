//
//  ConferenceCallService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import os.log

/// Manages real-time video calls, scheduling, and session tracking
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
            "status": "upcoming"
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

    /// Joins an existing conference call
    /// - Parameters:
    ///   - callID: The ID of the conference call.
    ///   - userID: The ID of the user joining the call.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func joinConferenceCall(callID: String, userID: String, completion: @escaping (Bool, Error?) -> Void) {
        let callRef = db.collection("conferenceCalls").document(callID)

        callRef.updateData([
            "participants": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                self.logger.error("Error joining conference call: \(error.localizedDescription)")
            } else {
                completion(false, error)
                self.logger.info("User \(userID) joined the conference call")
                completion(true, nil)
            }
        }
    }

    /// Updates the status of a conference call (live, completed, canceled)
    /// - Parameters:
    ///   - callID: The ID of the conference call.
    ///   - status: The new status of the conference call.
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
