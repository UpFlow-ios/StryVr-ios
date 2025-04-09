//
//  ReportsDashboardView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/9/25.
//

import SwiftUI

struct ReportsDashboardView: View {
    // MARK: - Mock Data
    var skillData: [SkillProgress] = [
        .init(skill: "Leadership", progress: 0.72),
        .init(skill: "UI/UX", progress: 0.64),
        .init(skill: "iOS Dev", progress: 0.89),
        .init(skill: "Problem Solving", progress: 0.58)
    ]

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    
                    // MARK: - Header
                    Text("Reports")
                        .foregroundColor(.whiteText)
                        .font(FontStyle.title)
                        .padding(.top, Spacing.large)
                        .accessibilityLabel("Reports Dashboard")

                    // MARK: - Bar Chart Card
                    if skillData.isEmpty {
                        Text("No skill data available")
                            .font(FontStyle.caption)
                            .foregroundColor(.lightGray)
                            .accessibilityLabel("No skill data available")
                    } else {
                        StryVrChartCard(data: skillData)
                            .accessibilityLabel("Skill progress chart with \(skillData.count) skills")
                    }

                    // MARK: - Circular Progress Grid
                    StryVrCardView(title: "Skill Breakdown") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.medium) {
                            ForEach(skillData) { skill in
                                StryVrProgressCircle(progress: skill.progress, label: skill.skill)
                                    .accessibilityLabel("\(skill.skill) progress: \(Int(skill.progress * 100)) percent")
                            }
                        }
                        .padding(.top, Spacing.small)
                    }

                    // MARK: - Daily Metrics
                    StryVrCardView(title: "Learning Metrics") {
                        VStack(alignment: .leading, spacing: Spacing.medium) {
                            HStack {
                                Text("Streak")
                                Spacer()
                                Text("12 Days")
                            }
                            .font(FontStyle.body)
                            .foregroundColor(.whiteText)
                            .accessibilityLabel("Streak: 12 Days")

                            HStack {
                                Text("Last Activity")
                                Spacer()
                                Text("Today at 08:42")
                            }
                            .accessibilityLabel("Last Activity: Today at 08:42")

                            HStack {
                                Text("Monthly Growth")
                                Spacer()
                                Text("22% ↑")
                            }
                            .accessibilityLabel("Monthly Growth: 22 percent increase")
                        }
                        .foregroundColor(.lightGray)
                    }

                    Spacer()
                }
                .padding(.horizontal, Spacing.large)
            }
        }
    }
}
```

### Changes:
1. **Dynamic Accessibility**: Added dynamic `accessibilityLabel` for the chart and progress circles.
2. **Default Data**: Made `skillData` a parameter with a default value for reusability.
3. **Consistency**: Ensured consistent font usage and fallback view styling.
