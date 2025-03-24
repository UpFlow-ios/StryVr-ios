import SwiftUI

/// A customizable button component for StryVr
struct CustomButton: View {
    /// The title of the button
    var title: String
    /// The action to perform when the button is tapped
    var action: () -> Void
    /// The background color of the button
    var backgroundColor: Color = Color.blue
    /// The text color of the button
    var textColor: Color = Color.white
    /// Optional SF Symbol icon for the button
    var icon: String?
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
