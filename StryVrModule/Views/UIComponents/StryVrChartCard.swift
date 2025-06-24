
//
//  StryVrChartCard.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📊 Skill Progress Chart – Themed Card View with Bar Chart
//

import Foundation
import SwiftUI

struct StryVrChartCard: View {
    var data: [SkillProgress]
    var chartHeight: CGFloat = 180
    var title: String = "Skill Progress"
    var barColor: Color = Theme.Colors.accent

    var body: some View {
        StryVrCardView(title: title) {
            if data.isEmpty {
                Text("No data available")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("No data available")
                    .accessibilityHint("The chart does not have any data to display")
            } else {
                Chart(data) {
                    BarMark(
                        x: .value("Skill", $0.skill),
                        y: .value("Progress", $0.progress)
                    )
                    .foregroundStyle(barColor)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .automatic)
                }
                .frame(height: chartHeight)
                .accessibilityLabel("Bar chart showing skill progress")
                .accessibilityHint("Displays the progress of various skills as a bar chart")
            }
        }
    }
}
