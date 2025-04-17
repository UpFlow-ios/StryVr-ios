//
//  MentorSessionListView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//  🗓️ Mentor Session Tracker – Booked & Past Learning Events
//

import SwiftUI

struct MentorSession: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct MentorSessionListView: View {
    @State private var sessions: [MentorSession] = [
        MentorSession(title: "Session 1", date: Date()),
        MentorSession(title: "Session 2", date: Date().addingTimeInterval(86400)),
        MentorSession(title: "Session 3", date: Date().addingTimeInterval(172800))
    ]

    var body: some View {
        NavigationStack {
            if sessions.isEmpty {
                Text("No sessions available.")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityLabel("No sessions available")
            } else {
                List(sessions) { session in
                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        Text(session.title)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textPrimary)

                        Text(session.date.formatted(date: .abbreviated, time: .omitted))
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding(.vertical, Theme.Spacing.small)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(session.title) on \(session.date.formatted(.dateTime.month().day().year()))")
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Mentor Sessions")
            .background(Theme.Colors.background)
        }
    }
}

#Preview {
    MentorSessionListView()
}
