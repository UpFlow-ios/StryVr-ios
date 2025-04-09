
import SwiftUI

struct StryVrCardView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat.Spacing.small) { // Ensure Spacing is defined
            Text(title)
                .font(Font.Style.heading) // Ensure FontStyle is defined
                .foregroundColor(.neonBlue)
                .accessibilityLabel("Card title: \(title)")
            content
        }
        .padding()
        .background(Color.card)
        .cornerRadius(12)
        .shadow(color: .neonBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}
