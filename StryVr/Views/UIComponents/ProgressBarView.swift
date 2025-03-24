import SwiftUI

/// A sleek progress bar for tracking user skill development
struct ProgressBarView: View {
    /// Progress value between 0 and 1
    @Binding var progress: Double
    /// Color of the progress bar
    var color: Color = Color.green

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray.opacity(0.2))

                    .frame(width: geometry.size.width * CGFloat(progress), height: 10)
                    .foregroundColor(color)
            }
        }
        .frame(height: 10)
    }
}
