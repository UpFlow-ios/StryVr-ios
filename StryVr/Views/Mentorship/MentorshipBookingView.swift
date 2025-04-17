//
//  MentorshipBookingView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//  🗓️ Mentor Session Booking – Select Mentor + Date + Confirmation
//

import SwiftUI

struct MentorshipBookingView: View {
    @State private var selectedMentor: Mentor?
    @State private var selectedDate: String = ""
    @State private var isBookingConfirmed = false
    @State private var errorMessage: String?

    let mentors: [Mentor] = [
        Mentor(id: "1", name: "Jane Doe", expertise: ["Business Strategy"], availableDates: ["2024-03-10", "2024-03-15"], profileImageURL: "https://example.com/jane.jpg"),
        Mentor(id: "2", name: "John Smith", expertise: ["Tech Leadership"], availableDates: ["2024-03-12", "2024-03-18"], profileImageURL: "https://example.com/john.jpg")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {

                    // MARK: - Header
                    Text("Book a Mentor")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.top)

                    // MARK: - Mentor List or Empty State
                    if mentors.isEmpty {
                        Text("No mentors available at the moment.")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("No mentors available")
                    } else {
                        ForEach(mentors) { mentor in
                            HStack(spacing: Theme.Spacing.medium) {
                                AsyncImage(url: URL(string: mentor.profileImageURL)) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .accessibilityLabel("\(mentor.name)'s profile picture")

                                VStack(alignment: .leading) {
                                    Text(mentor.name)
                                        .font(Theme.Typography.body)
                                        .foregroundColor(Theme.Colors.textPrimary)

                                    Text(mentor.expertise.joined(separator: ", "))
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }

                                Spacer()

                                Button("Select") {
                                    selectedMentor = mentor
                                    selectedDate = ""
                                    isBookingConfirmed = false
                                    errorMessage = nil
                                }
                                .buttonStyle(.bordered)
                                .accessibilityLabel("Select \(mentor.name)")
                            }
                            .padding(.vertical, Theme.Spacing.small)
                        }
                    }

                    // MARK: - Date Selection
                    if let mentor = selectedMentor {
                        Text("Selected Mentor: \(mentor.name)")
                            .font(Theme.Typography.subheadline.bold())
                            .padding(.top)

                        Picker("Select a Date", selection: $selectedDate) {
                            ForEach(mentor.availableDates, id: \.self) { date in
                                Text(date)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.vertical, Theme.Spacing.small)
                        .accessibilityLabel("Select a date for your session")

                        // MARK: - Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(Theme.Typography.caption)
                                .foregroundColor(.red)
                                .accessibilityLabel("Error: \(error)")
                        }

                        Button("Confirm Booking") {
                            if selectedDate.isEmpty {
                                errorMessage = "Please select a date before confirming."
                            } else {
                                // 🔐 TODO: Send booking to Firestore
                                isBookingConfirmed = true
                                errorMessage = nil
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, Theme.Spacing.small)
                        .accessibilityLabel("Confirm booking for \(mentor.name) on \(selectedDate)")
                    }

                    // MARK: - Confirmation Message
                    if isBookingConfirmed {
                        Text("✅ Booking Confirmed!")
                            .foregroundColor(.green)
                            .font(Theme.Typography.caption.bold())
                            .padding(.top, Theme.Spacing.small)
                            .accessibilityLabel("Booking confirmed")
                    }

                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
            .navigationTitle("Book a Session")
        }
    }
}

#Preview {
    MentorshipBookingView()
}
