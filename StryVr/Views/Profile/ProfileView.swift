//
//  ProfileView.swift
//  StryVr
//
//  👤 Connected Profile View with AuthViewModel Integration
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.medium) {
                    // MARK: - Profile Image

                    if let photoURL = authViewModel.userSession?.photoURL {
                        AsyncImage(url: photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case let .success(image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            case .failure:
                                fallbackImage
                            @unknown default:
                                fallbackImage
                            }
                        }
                    } else {
                        fallbackImage
                    }

                    // MARK: - Name & Email

                    Text(authViewModel.userSession?.displayName ?? "User")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text(authViewModel.userSession?.email ?? "No email available")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)

                    // MARK: - Log Out Button

                    Button(action: {
                        simpleHaptic()
                        authViewModel.signOut()
                    }) {
                        Text("Log Out")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.whiteText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.accent)
                            .cornerRadius(Theme.CornerRadius.medium)
                            .padding(.top, Theme.Spacing.large)
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Profile")
                .background(Theme.Colors.background)
            }
        }
    }

    private var fallbackImage: some View {
        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.5))
            .animateSymbol(true, type: .bounce)
            .shadow(color: .blue.opacity(0.5), radius: 10)
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
