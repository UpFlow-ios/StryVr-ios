//
//  SettingsView.swift
//  StryVr
//
//  📄 User Settings Screen – Edit Profile, Notifications, Account Info
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Profile Section

                Section(header: Text("Profile")) {
                    NavigationLink(destination: EditProfileView()) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                }

                // MARK: - Notifications Section (Future Feature)

                Section(header: Text("Preferences")) {
                    NavigationLink(destination: NotificationPreferencesView()) {
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    .disabled(true) // Coming Soon
                }

                // MARK: - Account Info Section

                Section(header: Text("Account")) {
                    HStack {
                        Label("Email", systemImage: "envelope")
                        Spacer()
                        Text(authViewModel.userSession?.email ?? "Unknown")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    HStack {
                        Label("App Version", systemImage: "gear")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    if let privacyURL = URL(string: "https://stryvr.app/privacy") {
                        Link(destination: privacyURL) {
                            Label("Privacy Policy", systemImage: "lock.shield")
                        }
                    }
                }

                // MARK: - Danger Zone

                Section {
                    Button(role: .destructive) {
                        simpleHaptic()
                        authViewModel.signOut()
                    } label: {
                        Label("Log Out", systemImage: "arrow.backward.circle")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .background(Theme.Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Simple Haptic

    private func simpleHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel.shared)
}
