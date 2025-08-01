import StryVr.Models
import SwiftUI
import ThemeManager

struct SubscriptionOption: View {
    let plan: SubscriptionPlan
    @Binding var selectedPlan: SubscriptionPlan

    var isSelected: Bool { plan == selectedPlan }

    var body: some View {
        Button(
            action: { selectedPlan = plan },
            label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.displayName)
                        .font(Font.Style.title)
                        .foregroundColor(.white)
                    Text(plan.description)
                        .font(Font.Style.body)
                        .foregroundColor(.gray)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                        .shadow(color: Theme.Colors.glowAccent, radius: 6)
                }
            }
            .padding()
            .background(isSelected ? Theme.Colors.glassAccent : Theme.Colors.card)
            .cornerRadius(Theme.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .stroke(isSelected ? Theme.Colors.accent : Color.clear, lineWidth: 2)
            )
            .shadow(color: Theme.Colors.glowPrimary, radius: isSelected ? 10 : 4)
            }
        )
        .buttonStyle(.plain)
        .animation(.easeInOut, value: isSelected)
        .accessibilityLabel("Select \(plan.displayName) plan")
    }
}
