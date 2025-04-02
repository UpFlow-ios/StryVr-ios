//
//  BusinessAnalyticsDashboard.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import SwiftUI
import Charts

struct BusinessAnalyticsDashboard: View {
    @State private var teamReports: [LearningReport] = []
    
    private var averageProgressBySkill: [String: Double] {
        ReportAnalysisHelper.calculateAverageSkillProgress(from: teamReports)
    }
    
    private var topPerformers: [UserModel] {
        ReportAnalysisHelper.findTopUsers(from: teamReports)
    }
    
    private var lowPerformingSkills: [String] {
        ReportAnalysisHelper.findWeakSkills(from: teamReports, threshold: 60)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("Business Analytics")
                        .font(.largeTitle.bold())
                        .padding(.top)
                        .padding(.horizontal)

                    Group {
                        Text("Average Skill Progress")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart {
                            ForEach(averageProgressBySkill.sorted(by: { $0.key < $1.key }), id: \.key) { skill, avg in
                                BarMark(
                                    x: .value("Skill", skill),
                                    y: .value("Average", avg)
                                )
                                .foregroundStyle(.blue)
                            }
                        }
                        .frame(height: 240)
                        .padding(.horizontal)
                    }

                    Group {
                        Text("Top Performers")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(topPerformers.prefix(3)) { user in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                        .font(.subheadline.bold())
                                    Text("Avg Progress: \(String(format: "%.1f", user.averageProgress))%")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }

                    if !lowPerformingSkills.isEmpty {
                        Group {
                            Text("Skills Needing Attention")
                                .font(.headline)
                                .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(lowPerformingSkills, id: \.self) { skill in
                                    Text("• \(skill)")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Team Insights")
            .onAppear {
                loadData()
            }
        }
    }

    // MARK: - Data Fetch Logic

    private func loadData() {
        ReportGeneration.shared.fetchTeamReports { reports in
            DispatchQueue.main.async {
                self.teamReports = reports
            }
        }
    }
}
