import Foundation
import OSLog
import SwiftUI

struct LearningPathsView: View {
    @State private var learningPaths: [LearningPath] = [
        LearningPath(title: "iOS Development", progress: 70),
        LearningPath(title: "SwiftUI Mastery", progress: 50),
        LearningPath(title: "AI & Machine Learning", progress: 30),
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Learning Paths")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                    .accessibilityLabel("Learning Paths Header")
                    .accessibilityHint("Displays a list of your learning paths")

                if learningPaths.isEmpty {
                    Text("No learning paths available.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .accessibilityLabel("No learning paths available")
                } else {
                    List(learningPaths) { path in
                        LearningPathCard(path: path)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Learning Paths")
        }
    }
}

// MARK: - Card UI

struct LearningPathCard: View {
    let path: LearningPath
    var cardColor: Color = .init(UIColor.systemBackground)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(path.title)
                .font(.headline)
                .accessibilityLabel("Learning path title: \(path.title)")

            ProgressBarView(progress: .constant(Double(path.progress) / 100.0))
                .frame(height: 10)
                .accessibilityLabel("Progress bar for \(path.title)")
                .accessibilityValue("\(path.progress)% completed")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(cardColor).shadow(radius: 2))
    }
}

// MARK: - Preview

#Preview {
    LearningPathsView()
}
