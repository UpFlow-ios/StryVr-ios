import SwiftUI
import os.log

/// Allows users to submit feedback on a mentor session
struct MentorFeedbackView: View {
    @State private var feedback: String = ""
    @State private var rating: Double = 4.0
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "MentorFeedbackView")

    var body: some View {
        VStack {
            Text("Rate Your Mentor")
                .font(.title2)

            Slider(value: $rating, in: 1...5, step: 1)
                .padding()

            TextField("Leave a comment...", text: $feedback)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit Feedback") {
                submitFeedback()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    /// Submits the feedback and logs the result
    private func submitFeedback() {
        guard !feedback.isEmpty else {
            logger.error("Feedback cannot be empty")
            return
        }
        logger.info("Feedback Submitted: \(feedback), Rating: \(rating)")
    }
}
