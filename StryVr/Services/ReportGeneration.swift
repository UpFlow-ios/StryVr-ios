//
//  ReportGeneration.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import FirebaseFirestore
import os.log

/// Generates AI-powered learning reports, skill analysis, and mentor insights
final class ReportGeneration {

    static let shared = ReportGeneration()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ReportGeneration")

    private init() {}

    /// Generates a personalized learning report for a user
    /// - Parameters:
    ///   - userID: The ID of the user.
    ///   - completion: A closure that returns an optional `LearningReport`.
    func generateLearningReport(for userID: String, completion: @escaping (LearningReport?) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                self.logger.error("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let skills = data["skills"] as? [String] ?? []
            let progress = data["progress"] as? [String: Double] ?? [:]

            let report = LearningReport(
                userID: userID,
                skillSummary: self.generateSkillSummary(skills, progress: progress),
                progressInsights: self.generateProgressInsights(progress),
                recommendations: self.generateAIRecommendations(skills, progress: progress)
            )

            completion(report)
        }
    }

    /// Generates a mentor impact report
    /// - Parameters:
    ///   - mentorID: The ID of the mentor.
    ///   - completion: A closure that returns an optional `MentorReport`.
    func generateMentorReport(for mentorID: String, completion: @escaping (MentorReport?) -> Void) {
        db.collection("mentors").document(mentorID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                self.logger.error("Error fetching mentor data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let sessionsCompleted = data["sessionsCompleted"] as? Int ?? 0
            let averageRating = data["averageRating"] as? Double ?? 0.0
            let feedback = data["feedback"] as? [String] ?? []

            let report = MentorReport(
                mentorID: mentorID,
                sessionCount: sessionsCompleted,
                averageRating: averageRating,
                feedbackSummary: feedback.joined(separator: ", ")
            )

            completion(report)
        }
    }

    /// Creates a summary of user skills and progress
    /// - Parameters:
    ///   - skills: An array of user skills.
    ///   - progress: A dictionary of skill progress.
    /// - Returns: A summary string of skills and progress.
    private func generateSkillSummary(_ skills: [String], progress: [String: Double]) -> String {
        return skills.map { skill in
            let skillProgress = progress[skill] ?? 0
            return "\(skill): \(Int(skillProgress * 100))% complete"
        }.joined(separator: "\n")
    }

    /// Generates AI-driven progress insights
    /// - Parameter progress: A dictionary of skill progress.
    /// - Returns: A string of progress insights.
    private func generateProgressInsights(_ progress: [String: Double]) -> String {
        let topSkill = progress.max { a, b in a.value < b.value }?.key ?? "No skill data"

