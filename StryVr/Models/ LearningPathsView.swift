//
//  LearningPath.swift
//  StryVr
//
//  🔁 Reusable model for learning paths
//

import Foundation

struct LearningPath: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let progress: Double
    let isCompleted: Bool
}

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "LearningPathsView")

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    Text("Learning Paths")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top, Theme.Spacing.large)

                    ForEach(learningPaths) { path in
                        learningPathCard(for: path)
                    }
                }
                .padding()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            logger.info("📚 LearningPathsView appeared with \(learningPaths.count) paths")
        }
    }

    // MARK: - Learning Path Card
    private func learningPathCard(for path: LearningPath) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                    Text(path.title)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(path.description)
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                Spacer()

                if path.isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }

            ProgressView(value: path.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Theme.Colors.accent))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(color: Theme.Colors.accent.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    LearningPathsView()
}
