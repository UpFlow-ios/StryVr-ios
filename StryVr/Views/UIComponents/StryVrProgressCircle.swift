import SwiftUI

struct StryVrProgressCircle: View {
    var progress: Double // 0.0 to 1.0
    var label: String
    var size: CGFloat = 80 // Default size

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.lightGray.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: max(0.0, min(progress, 1.0))) // Clamp progress
                    .stroke(Color.neonBlue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                Text("\(Int(max(0.0, min(progress, 1.0)) * 100))%") // Clamp progress
                    .font(.caption)
                    .foregroundColor(.whiteText)
                    .accessibilityLabel("Progress: \(Int(progress * 100)) percent")
            }
            .frame(width: size, height: size)

            Text(label)
                .font(.caption)
                .foregroundColor(.lightGray)
                .accessibilityLabel("Label: \(label)")
        }
        .accessibilityElement(children: .combine)
    }
}
