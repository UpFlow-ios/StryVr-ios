import SwiftUI

/// A tag-style view for displaying skills in a compact format
struct SkillTagView: View {
    /// The skill to display
    @Binding var skill: String

    var body: some View {
        Text(skill)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
