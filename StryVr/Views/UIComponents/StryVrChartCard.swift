
import SwiftUI
import Charts

struct SkillProgress: Identifiable {
    let id = UUID()
    let skill: String
    let progress: Double
}

struct StryVrChartCard: View {
    var data: [SkillProgress]
    var chartHeight: CGFloat = 180 // Default chart height

    var body: some View {
        StryVrCardView(title: "Skill Progress") {
            if data.isEmpty {
                Text("No data available")
                    .font(.caption)
                    .foregroundColor(.lightGray)
                    .accessibilityLabel("No data available")
            } else {
                Chart(data) {
                    BarMark(
                        x: .value("Skill", $0.skill),
                        y: .value("Progress", $0.progress)
                    )
                    .foregroundStyle(Color.neonBlue)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: chartHeight)
                .accessibilityLabel("Skill progress chart")
            }
        }
    }
}
