//
//  MentorListView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//  🧑‍🏫 Mentor List Carousel – Themed & Scalable Mentor Preview UI
//

import SwiftUI

struct MentorListView: View {
    let mentors: [Mentor]

    var body: some View {
        if mentors.isEmpty {
            Text("No mentors available.")
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding()
                .accessibilityLabel("No mentors available")
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.medium) {
                    ForEach(mentors) { mentor in
                        VStack(alignment: .center, spacing: Theme.Spacing.small) {

                            // MARK: - Profile Image Placeholder
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Theme.Colors.accent)
                                .background(Theme.Colors.card)
                                .clipShape(Circle())
                                .accessibilityLabel("\(mentor.name)'s profile picture")

                            // MARK: - Mentor Name
                            Text(mentor.name)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)

                            // MARK: - Mentor Expertise
                            Text(mentor.expertise.joined(separator: ", "))
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .accessibilityLabel("Expertise: \(mentor.expertise.joined(separator: ", "))")
                        }
                        .frame(width: 140)
                        .padding()
                        .background(Theme.Colors.card)
                        .cornerRadius(Theme.CornerRadius.large)
                        .shadow(color: Theme.Colors.textSecondary.opacity(0.1), radius: 3, x: 0, y: 2)
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
            .accessibilityLabel("Mentor carousel")
        }
    }
}

#Preview {
    MentorListView(mentors: [
        Mentor(id: "1", name: "Alice Johnson", expertise: ["iOS", "SwiftUI"]),
        Mentor(id: "2", name: "Dev Patel", expertise: ["AI", "Firebase"]),
        Mentor(id: "3", name: "Sarah Lee", expertise: ["Design", "UX"])
    ])
}
