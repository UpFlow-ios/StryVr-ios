import FirebaseFirestore
import Combine
import CocoaLumberjackSwift

class MentorshipService {
    static let shared = MentorshipService()
    private let db = Firestore.firestore()

    func bookMentorshipSession(userID: String, mentor: Mentor, date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let bookingData: [String: Any] = [
            "userID": userID,
            "mentorID": mentor.id,
            "mentorName": mentor.name,
            "date": date
        ]
        
        db.collection("mentorship_sessions").addDocument(data: bookingData) { error in
            if let error = error {
                DDLogError("Failed to book session: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                DDLogInfo("Mentorship session booked successfully")
                completion(.success(()))
            }
        }
    }
}

