import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import os.log

/// Handles mentorship session booking, retrieval, and admin management
final class MentorshipService {
    static let shared = MentorshipService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "MentorshipService")

    private init() {}

    // MARK: - Book Session
    /// Books a mentorship session
    func bookMentorshipSession(session: MentorshipSession, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !session.id.isEmpty else {
            logger.error("❌ Invalid session ID")
            completion(.failure(MentorshipError.invalidInput))
            return
        }

        do {
            try db.collection("mentorship_sessions")
                .document(session.id)
                .setData(from: session) { error in
                    if let error = error {
                        self.logger.error("❌ Failed to book session: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        self.logger.info("✅ Mentorship session booked for mentor \(session.mentorID)")
                        completion(.success(()))
                    }
                }
        } catch {
            logger.error("📦 Encoding error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    // MARK: - Fetch Sessions For User
    /// Fetches mentorship sessions for a specific user
    func fetchSessions(forUserID userID: String, completion: @escaping (Result<[MentorshipSession], Error>) -> Void) {
        guard !userID.isEmpty else {
            logger.error("❌ Invalid user ID")
            completion(.failure(MentorshipError.invalidInput))
            return
        }

        db.collection("mentorship_sessions")
            .whereField("menteeID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.logger.error("❌ Fetch error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let sessions: [MentorshipSession] = documents.compactMap { doc in
                    try? doc.data(as: MentorshipSession.self)
                }

                self.logger.info("📥 Fetched \(sessions.count) sessions for user \(userID)")
                completion(.success(sessions))
            }
    }

    // MARK: - Update Session
    /// Updates an existing mentorship session
    func updateSession(_ session: MentorshipSession, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !session.id.isEmpty else {
            logger.error("❌ Invalid session ID")
            completion(.failure(MentorshipError.invalidInput))
            return
        }

        do {
            try db.collection("mentorship_sessions")
                .document(session.id)
                .setData(from: session, merge: true) { error in
                    if let error = error {
                        self.logger.error("🛠️ Update failed: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        self.logger.info("✅ Session \(session.id) updated")
                        completion(.success(()))
                    }
                }
        } catch {
            logger.error("📦 Encoding error on update: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    // MARK: - Delete Session
    /// Deletes a mentorship session by ID
    func deleteSession(sessionID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !sessionID.isEmpty else {
            logger.error("❌ Invalid session ID")
            completion(.failure(MentorshipError.invalidInput))
            return
        }

        db.collection("mentorship_sessions").document(sessionID).delete { error in
            if let error = error {
                self.logger.error("🗑️ Failed to delete session: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                self.logger.info("✅ Session \(sessionID) deleted")
                completion(.success(()))
            }
        }
    }
}

/// Custom error type for mentorship operations
enum MentorshipError: LocalizedError {
    case invalidInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided."
        }
    }
}
