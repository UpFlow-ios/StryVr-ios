//
//  EditProfileView.swift
//  StryVr
//
//  🖊 Editable Profile View – Full Name & Bio
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var fullName: String = ""
    @State private var bio: String = ""
    @State private var isSaving: Bool = false
    @State private var successMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Full Name")) {
                    TextField("Enter your full name", text: $fullName)
                        .autocapitalization(.words)
                }

                Section(header: Text("Bio")) {
                    TextEditor(text: $bio)
                        .frame(height: 120)
                }

                Section {
                    Button(action: saveProfile) {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accent))
                        } else {
                            Text("Save Changes")
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
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        simpleHaptic()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                loadUserProfile()
            }
            .background(Theme.Colors.background.ignoresSafeArea())
        }
    }

    // MARK: - Load Existing Profile
    private func loadUserProfile() {
        fullName = authViewModel.userSession?.displayName ?? ""
        bio = "🚀 No bio available yet."
        // (Later you can fetch a real bio from Firestore if needed)
    }

    // MARK: - Save Updated Profile
    private func saveProfile() {
        isSaving = true
        simpleHaptic()
        
        // In the future: Save to Firebase Firestore or Realtime DB here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // Mock save delay
            isSaving = false
            successMessage = "✅ Profile updated successfully!"
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
    EditProfileView()
        .environmentObject(AuthViewModel.shared)
}
