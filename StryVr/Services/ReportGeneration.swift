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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "ReportGeneration")

    private init() {}

    // MARK: - Generate User Learning Report
    /// Generates a learning report for a specific user
    func generateLearningReport(for userID: String, completion: @escaping (LearningReport?) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid userID provided")
            completion(nil)
            return
        }

        db.collection("users").document(userID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                self.logger.error("❌ Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let skills = data["skills"] as? [String] ?? []
            let progress = data["progress"] as? [String: Double] ?? [:]

            let skillProgress: [SkillProgress] = skills.map { skill in
                SkillProgress(id: UUID().uuidString, skill: skill, progress: progress[skill] ?? 0)
            }

            let report = LearningReport(
                id: UUID().uuidString,
                userId: userID,
                generatedOn: Date(),
                skillImprovements: skillProgress,
                summary: self.generateProgressInsights(progress)
            )

            self.logger.info("📊 Learning report generated for user \(userID)")
            completion(report)
        }
    }

    // MARK: - Generate Mentor Report
    /// Generates a report for a specific mentor
    func generateMentorReport(for mentorID: String, completion: @escaping (MentorReport?) -> Void) {
        guard !mentorID.isEmpty else {
            logger.error("❌ Invalid mentorID provided")
            completion(nil)
            return
        }

        db.collection("mentors").document(mentorID).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                self.logger.error("❌ Error fetching mentor data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let sessionCount = data["sessionsCompleted"] as? Int ?? 0
            let rating = data["averageRating"] as? Double ?? 0.0
            let feedback = data["feedback"] as? [String] ?? []

            let report = MentorReport(
                id: UUID().uuidString,
                mentorId: mentorID,
                menteeFeedback: feedback,
                rating: rating,
                sessionCount: sessionCount,
                summary: "Mentor has completed \(sessionCount) sessions with an average rating of \(String(format: "%.1f", rating)).",
                reportDate: Date()
            )

            self.logger.info("🧠 Mentor report generated for \(mentorID)")
            completion(report)
        }
    }

    // MARK: - AI Summary Generators
    /// Generates a summary of skill progress
    private func generateSkillSummary(_ skills: [String], progress: [String: Double]) -> String {
        return skills.map { skill in
            let percent = Int((progress[skill] ?? 0.0) * 100)
        }.joined(separator: "\n")
    }

            return "\(skill): \(percent)%"
    /// Generates insights based on progress data
    private func generateProgressInsights(_ progress: [String: Double]) -> String {
        guard !progress.isEmpty else {
            return "No learning progress recorded yet."
        }

        let average = progress.values.reduce(0, +) / Double(progress.count)
        let topSkill = progress.max(by: { $0.value < $1.value })?.key ?? "N/A"
        let topValue = Int((progress[topSkill] ?? 0.0) * 100)

        return """
        📈 Average Skill Progress: \(Int(average * 100))%
        🚀 Top Skill: \(topSkill) at \(topValue)% mastery
        Keep learning to unlock new achievements!
        """
    }
}
