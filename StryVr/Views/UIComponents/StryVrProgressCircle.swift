//
//  StryVrProgressCircle.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//  🔵 Circular Progress Indicator for Skill Metrics or Challenge Completion
//

import SwiftUI

struct StryVrProgressCircle: View {
    var progress: Double // 0.0 to 1.0
    var label: String = "Progress"
    var size: CGFloat = 80
    var lineWidth: CGFloat = 8
    var backgroundColor: Color = Theme.Colors.textSecondary.opacity(0.2)
    var progressColor: Color = Theme.Colors.accent

    private var clampedProgress: Double {
        max(0.0, min(progress, 1.0))
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            ZStack {
                // Background Circle
                Circle()
                    .stroke(backgroundColor, lineWidth: lineWidth)

                // Progress Arc
                Circle()
                    .trim(from: 0, to: clampedProgress)
                    .stroke(
                        progressColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: clampedProgress)

                // Percentage Text
                Text("\(Int(clampedProgress * 100))%")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityLabel("Progress: \(Int(clampedProgress * 100)) percent")
                    .accessibilityHint("Indicates the current progress as a percentage")
            }
            .frame(width: size, height: size)

            // Label Below
            Text(label)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .accessibilityLabel("Label: \(label)")
                .accessibilityHint("Describes the purpose of the progress indicator")
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StryVrProgressCircle(progress: 0.72, label: "Leadership")
}
