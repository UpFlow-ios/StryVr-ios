import SwiftUI

/// Shown when a group challenge has been completed successfully
struct GroupChallengeCompleteView: View {
    let challengeTitle: String

    var body: some View {
        VStack(spacing: 16) {
            LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
                .frame(height: 200)
            Text("Group Challenge Complete!")
                .font(.title)
                .bold()
            Text("You and your team finished \(challengeTitle). Great job!")
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

#Preview {
    GroupChallengeCompleteView(challengeTitle: "SwiftUI Bootcamp")
}
