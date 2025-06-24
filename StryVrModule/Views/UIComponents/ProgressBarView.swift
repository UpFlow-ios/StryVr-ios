//
//  ProgressBarView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/6/25.
//  📈 Reusable Skill Progress Bar – Themed, Scalable & Animated
//

import SwiftUI

/// A sleek, themed horizontal progress bar used across the app
struct ProgressBarView: View {
    @Binding var progress: Double
    var color: Color = Theme.Colors.accent
    var backgroundColor: Color = Theme.Colors.textSecondary.opacity(0.15)
    var height: CGFloat = 10
    var cornerRadius: CGFloat = Theme.CornerRadius.small

    private var clampedProgress: Double {
        max(0.0, min(progress, 1.0))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: height)

                // Progress fill
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(width: geometry.size.width * clampedProgress, height: height)
                    .animation(.easeInOut, value: clampedProgress)
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress bar")
        .accessibilityValue("\(Int(clampedProgress * 100)) percent complete")
        .accessibilityHint("Indicates the progress of a task or skill")
    }
}

#Preview {
    StatefulPreviewWrapper(0.65) { value in
        ProgressBarView(progress: value)
            .padding()
    }
}

// MARK: - Helper for Preview Bindings

struct StatefulPreviewWrapper<Value: MutablePropertyWrapper & DynamicProperty, Content: View>: View where Value.Value: Equatable {
    @State private var value: Value.Value
    var content: (Binding<Value.Value>) -> Content

    init(_ initialValue: Value.Value, @ViewBuilder content: @escaping (Binding<Value.Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
