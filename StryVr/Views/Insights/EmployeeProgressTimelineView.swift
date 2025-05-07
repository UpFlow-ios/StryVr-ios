//
//  EmployeeProgressTimelineView.swift
//  StryVr
//
//  🕒 Progress Timeline – View employee milestones, feedback, and achievements over time
//

import SwiftUI
import Charts

struct EmployeeProgressTimelineView: View {
    @State private var timelineItems: [EmployeeTimelineEvent] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var employeeId: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    Text("📅 Progress Timeline")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    if isLoading {
                        ProgressView("Loading timeline...")
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else if timelineItems.isEmpty {
                        Text("No timeline events found.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(timelineItems) { event in
                            timelineCard(for: event)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Timeline")
            .background(Theme.Colors.background.ignoresSafeArea())
            .onAppear(perform: loadTimeline)
        }
    }

    // MARK: - Timeline Card
    private func timelineCard(for event: EmployeeTimelineEvent) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textPrimary)

            Text(event.description)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            Text(event.formattedDate)
                .font(Theme.Typography.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Theme.Colors.card)
        .cornerRadius(Theme.CornerRadius.medium)
        .shadow(radius: 2)
    }

    // MARK: - Load Timeline Data
    private func loadTimeline() {
        EmployeeProgressService.shared.fetchTimeline(for: employeeId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let events):
                    timelineItems = events
                case .failure:
                    errorMessage = "Failed to load timeline data."
                }
            }
        }
    }
}

#Preview {
    EmployeeProgressTimelineView(employeeId: "sample123")
}

