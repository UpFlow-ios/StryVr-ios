//
//  ProfileView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  👤 User Profile – Themed, Accessible, and Scalable Profile Layout
//

import SwiftUI

/// Displays user profile details
struct ProfileView: View {
    let user: UserModel

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.medium) {

                // MARK: - Profile Image
                if let urlString = user.profileImageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .accessibilityLabel("Loading profile image")
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .accessibilityLabel("Profile image of \(user.fullName)")
                        case .failure:
                            fallbackImage
                        @unknown default:
                            fallbackImage
                        }
                    }
                } else {
                    fallbackImage
                }

                // MARK: - Name & Bio
                Text(user.fullName)
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Full name: \(user.fullName)")

                Text(user.bio ?? "No bio available")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(user.bio ?? "No bio available")

                // MARK: - Future: Tabs (Achievements, Feedback, etc.)
                // 🔗 Placeholder for future sections

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .background(Theme.Colors.background)
        }
    }

    private var fallbackImage: some View {
        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.5))
            .accessibilityLabel("Profile image unavailable")
    }
}

#Preview {
    ProfileView(user: UserModel(
        id: "1",
        fullName: "Joe Dormond",
        bio: "iOS Dev | SwiftUI Enthusiast",
        profileImageURL: nil
    ))
}
