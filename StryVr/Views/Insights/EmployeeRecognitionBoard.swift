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
        EmployeeModel(name: "Alex Johnson", role: "Developer", avatar: "avatar_1", completedGoals: 18),
        EmployeeModel(name: "Briana Lee", role: "UX Designer", avatar: "avatar_2", completedGoals: 16),
        EmployeeModel(name: "Carlos Wang", role: "Marketing Lead", avatar: "avatar_3", completedGoals: 14)
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
                        Image(employee.avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(employee.name)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Text(employee.role)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.Colors.textSecondary)

                            ProgressView(value: Double(employee.completedGoals), total: 20)
                                .tint(Theme.Colors.accent)
                        }

                        Spacer()

                        Text("\(employee.completedGoals) Goals")
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

