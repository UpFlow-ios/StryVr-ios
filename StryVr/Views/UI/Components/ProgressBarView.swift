import SwiftUI

struct ProgressBarView: View {
    var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 8)
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(4)
            
            Rectangle()
                .frame(width: CGFloat(progress) * 200, height: 8)
                .foregroundColor(.blue)
                .cornerRadius(4)
        }
        .frame(width: 200)
    }
}
