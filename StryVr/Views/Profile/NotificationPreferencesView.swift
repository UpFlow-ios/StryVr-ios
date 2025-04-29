//
//  NotificationPreferencesView.swift
//  StryVr
//
//  🔔 Notification Preferences – Themed, Accessible, and Scalable
//

import SwiftUI

struct NotificationPreferencesView: View {
    @State private var generalNotificationsEnabled: Bool = true
    @State private var mentorshipNotificationsEnabled: Bool = true
    @State private var challengeNotificationsEnabled: Bool = true
    @State private var silentModeEnabled: Bool = false

    @State private var isSaving: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Notification Toggles
                Section(header: Text("Notification Settings")) {
                    Toggle("General App Updates", isOn: $generalNotificationsEnabled)
                    Toggle("Mentorship Session Reminders", isOn: $mentorshipNotificationsEnabled)
                    Toggle("New Skill Challenges", isOn: $challengeNotificationsEnabled)
                }

                // MARK: - Silent Mode
                Section(header: Text("Silent Mode")) {
                    Toggle("Mute All Notifications", isOn: $silentModeEnabled)
                        .onChange(of: silentModeEnabled) { newValue in
                            if newValue {
                                disableAllNotifications()
                            }
                        }
                }

                // MARK: - Save Button
                Section {
                    Button(action: savePreferences) {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        } else {
                            Text("Save Preferences")
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.whiteText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.Colors.accent)
                                .cornerRadius(Theme.CornerRadius.medium)
                        }
                    }
                    .disabled(isSaving)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .background(Theme.Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Disable All Notifications Helper
    private func disableAllNotifications() {
        generalNotificationsEnabled = false
        mentorshipNotificationsEnabled = false
        challengeNotificationsEnabled = false
    }

    // MARK: - Save Preferences
    private func savePreferences() {
        isSaving = true
        simpleHaptic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // Simulate save delay
            isSaving = false
            presentationMode.wrappedValue.dismiss()
        }
    }

    // MARK: - Simple Haptic
    private func simpleHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    NotificationPreferencesView()
}
