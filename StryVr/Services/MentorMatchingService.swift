//
//  MentorMatchingService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// AI-driven mentor-mentee matching service
final class MentorMatchingService {

    static let shared = MentorMatchingService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MentorMatchingService")

    private init() {}

    /// Finds the best mentor match for a mentee based on skills and goals
    /// - Parameters:
    ///   - userID: The ID of the user (mentee).
    ///   - completion: A closure that returns an optional MentorModel.
    func findMentor(for userID: String, completion: @escaping (MentorModel?) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let userData = snapshot?.data(), error == nil else {
                self.logger.error("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let userSkills = userData["skills"] as? [String] ?? []
            let learningGoals = userData["learningGoals"] as? [String] ?? []

            self.findMatchingMentor(for: userSkills, learningGoals: learningGoals, completion: completion)
        }
    }

    /// Fetches mentors and finds the best match based on skills & goals
    /// - Parameters:
    ///   - skills: The skills of the mentee.
    ///   - learningGoals: The learning goals of the mentee.
    ///   - completion: A closure that returns an optional MentorModel.
    private func findMatchingMentor(for skills: [String], learningGoals: [String], completion: @escaping (MentorModel?) -> Void) {
        db.collection("mentors").order(by: "rating", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                self.logger.error("Error fetching mentors: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let mentors = documents.compactMap { doc -> MentorModel? in
                try? doc.data(as: MentorModel.self)
            }

            let bestMatch = self.findBestMatch(from: mentors, skills: skills, learningGoals: learningGoals)
            completion(bestMatch)
        }
    }

    /// Determines the best mentor match based on skill overlap & expertise
    /// - Parameters:
    ///   - mentors: The list of available mentors.
    ///   - skills: The skills of the mentee.
    ///   - learningGoals: The learning goals of the mentee.
    /// - Returns: The best matching MentorModel.
    private func findBestMatch(from mentors: [MentorModel], skills: [String], learningGoals: [String]) -> MentorModel? {
