//
//  EmployeeRecognitionBoard.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🏅 Recognition Board – Highlights Top Performing Employees
//

import SwiftUI

struct EmployeeRecognitionBoard: View {
    let topEmployees: [EmployeeModel] = [
        EmployeeModel(
            id: "emp001",
            name: "Alex Johnson",
            role: "Developer",
            department: "Engineering",
            email: "alex@stryvr.com",
            joinDate: Date(),
            skills: [],
            feedbackEntries: [],
            performanceRating: 4.8,
            goalsAchieved: 18,
            isActive: true
        ),
        EmployeeModel(
            id: "emp002",
            name: "Briana Lee",
            role: "UX Designer",
            department: "Design",
            email: "briana@stryvr.com",
            joinDate: Date(),
            skills: [],
            feedbackEntries: [],
            performanceRating: 4.6,
            goalsAchieved: 16,
            isActive: true
        ),
        EmployeeModel(
            id: "emp003",
            name: "Carlos Wang",
            role: "Marketing Lead",
            department: "Marketing",
            email: "carlos@stryvr.com",
            joinDate: Date(),
            skills: [],
            feedbackEntries: [],
            performanceRating: 4.4,
            goalsAchieved: 14,
            isActive: true
        ),
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                Text("🏅 Recognition Board")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal)

                ForEach(topEmployees.indices, id: \._self) { index in
                    let employee = topEmployees[index]
                    HStack(spacing: Theme.Spacing.medium) {
                        // Placeholder avatar
                        Circle()
                            .fill(Theme.Colors.accent.opacity(0.3))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(String(employee.name.prefix(1)))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.Colors.accent)
                            )

                        VStack(alignment: .leading) {
                            Text(employee.name)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Text(employee.role)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)

                            ProgressView(value: Double(employee.goalsAchieved), total: 20)
                                .tint(Theme.Colors.accent)
                        }

                        Spacer()

                        Text("\(employee.goalsAchieved) Goals")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.accent)
                    }
                    .padding()
                    .background(Theme.Colors.card)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Top Employees")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EmployeeRecognitionBoard()
}
