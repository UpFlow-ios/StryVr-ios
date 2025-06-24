//
//  TeamHealthChart.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  📈 Team Health Chart – Visual comparison of productivity vs. wellness
//

import Charts
import SwiftUI

struct TeamHealthChart: View {
    let stats: [TeamHealthStat]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("📊 Team Health Comparison")
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal)

            Chart {
                ForEach(stats) { stat in
                    BarMark(
                        x: .value("Employee", stat.employeeName),
                        y: .value("Productivity", stat.productivityScore)
                    )
                    .foregroundStyle(Theme.Colors.accent.opacity(0.9))

                    BarMark(
                        x: .value("Employee", stat.employeeName),
                        y: .value("Wellness", stat.wellnessScore)
                    )
                    .foregroundStyle(Theme.Colors.accent.opacity(0.5))
                }
            }
            .frame(height: 260)
            .padding()
            .background(Theme.Colors.card)
            .cornerRadius(Theme.CornerRadius.medium)
            .shadow(radius: 3)
            .accessibilityLabel("Bar chart showing productivity and wellness per employee.")
        }
    }
}
