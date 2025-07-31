//
//  GroupChallengesView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/7/25.
//  🏆 Group Challenges – Scalable UI for Skill Competitions
//

import SwiftUI

// MARK: - ViewModel

class GroupChallengesViewModel: ObservableObject {
    @Published var challenges: [String] = [
        "Design Sprint",
        "Startup Pitch",
    ]
}

// MARK: - View

struct GroupChallengesView: View {
    @StateObject private var viewModel = GroupChallengesViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.challenges.isEmpty {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)

                    Text("No challenges available.")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel("No challenges available message")
                }
                .padding()
            } else {
                List(viewModel.challenges, id: \.self) { challenge in
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(Theme.Colors.accent)
                            .accessibilityHidden(true)

                        Text(challenge)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityLabel("\(challenge) Challenge")
                            .accessibilityHint(
                                "Tap to view details about the \(challenge) challenge")
                    }
                    .padding(.vertical, Theme.Spacing.small)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Group Challenges")
                .background(Theme.Colors.background)
        }
    }
}

#Preview {
    GroupChallengesView()
}
