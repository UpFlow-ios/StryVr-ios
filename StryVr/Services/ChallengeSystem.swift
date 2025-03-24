//
//  ChallengeSystem.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// Manages learning challenges, competitions, and streak tracking
final class ChallengeSystem {
    
    static let shared = ChallengeSystem()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ChallengeSystem")
    
    private init() {}

    /// Creates a new learning challenge
    /// - Parameters:
    ///   - title: The title of the challenge.
    ///   - description: The description of the challenge.
    ///   - reward: The reward for completing the challenge.
    ///   - durationDays: The duration of the challenge in days.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func createChallenge(title: String, description: String, reward: String, durationDays: Int, completion: @escaping (Bool, Error?) -> Void) {
        let challengeID = UUID().uuidString
        let endDate = Calendar.current.date(byAdding: .day, value: durationDays, to: Date()) ?? Date()
        
        let challengeData: [String: Any] = [
            "id": challengeID,
            "title": title,
            "description": description,
            "reward": reward,
            "startDate": Date(),
            "endDate": endDate,
            "participants": [],
            "completedUsers": []
        ]
        
        db.collection("challenges").document(challengeID).setData(challengeData) { error in
            if let error = error {
                self.logger.error("Error creating challenge: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("Challenge created successfully!")
                completion(true, nil)
            }
        }
    }

    /// Allows a user to join an active challenge
    /// - Parameters:
    ///   - challengeID: The ID of the challenge.
    ///   - userID: The ID of the user joining the challenge.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func joinChallenge(challengeID: String, userID: String, completion: @escaping (Bool, Error?) -> Void) {
        let challengeRef = db.collection("challenges").document(challengeID)
        
        challengeRef.updateData([
            "participants": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                self.logger.error("Error joining challenge: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("User \(userID) joined challenge \(challengeID)")
                completion(true, nil)
            }
        }
    }

    /// Marks a challenge as completed for a user
    /// - Parameters:
    ///   - challengeID: The ID of the challenge.
    ///   - userID: The ID of the user completing the challenge.
    ///   - completion: A closure that returns a boolean indicating success or failure, and an optional error.
    func completeChallenge(challengeID: String, userID: String, completion: @escaping (Bool, Error?) -> Void) {
        let challengeRef = db.collection("challenges").document(challengeID)
        
        challengeRef.updateData([
            "completedUsers": FieldValue.arrayUnion([userID])
        ]) { error in
            if let error = error {
                self.logger.error("Error marking challenge as completed: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self.logger.info("User \(userID) completed challenge \(challengeID)")
                completion(true, nil)
            }
        }
    }

    /// Fetches active challenges
    /// - Parameters:
    ///   - completion: A closure that returns an array of active challenges.
    func fetchActiveChallenges(completion: @escaping ([ChallengeModel]) -> Void) {
        db.collection("challenges")

