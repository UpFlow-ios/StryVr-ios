//
//  ProfileView.swift
//  StryVr
//
//  👤 Profile View with Liquid Glass + Apple Glow UI
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var skillsCount = 12
    @State private var badgesCount = 5
    @State private var goalsCount = 8

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Dark Gradient Background

                Theme.LiquidGlass.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.large) {
                        // MARK: - Header with Back Button

                        headerSection()

                        // MARK: - Profile Section

                        profileSection()

                        // MARK: - Skills/Badges/Goals Metrics

                        metricsSection()

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, Theme.Spacing.large)
                    .padding(.top, Theme.Spacing.large)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header Section

    private func headerSection() -> some View {
        HStack {
            Button(
                action: {
                    // Navigation back action
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
            )

            Spacer()

            Text("stryvr")
                .font(Theme.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(Theme.Colors.textPrimary)

            Spacer()

            // Invisible spacer for balance
            Color.clear
                .frame(width: 24, height: 24)
        }
        .padding(.bottom, Theme.Spacing.medium)
    }

    // MARK: - Profile Section

    private func profileSection() -> some View {
        VStack(spacing: Theme.Spacing.large) {
            // Profile Image
            if let photoURL = authViewModel.userSession?.photoURL {
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Theme.Colors.glassPrimary, lineWidth: 2)
                            )
                    case .failure:
                        fallbackImage
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                fallbackImage
            }

            // Name and Title
            VStack(spacing: Theme.Spacing.small) {
                Text(authViewModel.userSession?.displayName ?? "John Doe")
                    .font(Theme.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Professional")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            // Edit Profile Button
            Button(
                action: {
                    simpleHaptic()
                    // Navigate to edit profile
                },
                label: {
                    Text("Edit Profile")
                        .font(Theme.Typography.buttonText)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(Theme.Spacing.large)
                        .liquidGlassCard()
                        .liquidGlassGlow(
                            color: Theme.Colors.glowPrimary, radius: 10, intensity: 0.8)
                }
            )
            .buttonStyle(PlainButtonStyle())
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowPrimary, radius: 12, intensity: 0.6)
    }

    // MARK: - Metrics Section

    private func metricsSection() -> some View {
        HStack(spacing: 0) {
            // Skills
            metricItem(
                icon: "sparkles",
                title: "Skills",
                value: "\(skillsCount)",
                color: Theme.Colors.neonYellow,
                glowColor: Theme.Colors.glowYellow
            )

            // Divider
            Rectangle()
                .fill(Theme.Colors.glassPrimary)
                .frame(width: 1, height: 60)
                .padding(.vertical, Theme.Spacing.medium)

            // Badges
            metricItem(
                icon: "shield.fill",
                title: "Badges",
                value: "\(badgesCount)",
                color: Theme.Colors.neonBlue,
                glowColor: Theme.Colors.glowPrimary
            )

            // Divider
            Rectangle()
                .fill(Theme.Colors.glassPrimary)
                .frame(width: 1, height: 60)
                .padding(.vertical, Theme.Spacing.medium)

            // Goals
            metricItem(
                icon: "flag.fill",
                title: "Goals",
                value: "\(goalsCount)",
                color: Theme.Colors.neonGreen,
                glowColor: Theme.Colors.glowGreen
            )
        }
        .padding(Theme.Spacing.large)
        .liquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.glowSecondary, radius: 12, intensity: 0.6)
    }

    // MARK: - Metric Item

    private func metricItem(
        icon: String, title: String, value: String, color: Color, glowColor: Color
    ) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .neonGlow(color: glowColor, pulse: true)

            Text(title)
                .font(Theme.Typography.caption)
                .fontWeight(.medium)
                .foregroundColor(Theme.Colors.textPrimary)

            Text(value)
                .font(Theme.Typography.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var fallbackImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .foregroundColor(Theme.Colors.textSecondary)
            .overlay(
                Circle()
                    .stroke(Theme.Colors.glassPrimary, lineWidth: 2)
            )
    }

    private func simpleHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel.previewMock)
}
