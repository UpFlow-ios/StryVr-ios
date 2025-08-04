//
//  ReportsView.swift
//  StryVr
//
//  📊 Verified Professional Resume View – HR-Trusted Employment History
//  Shows verified past jobs, earnings, performance metrics, and professional achievements
//

import SwiftUI

struct ReportsView: View {
    @StateObject private var reportsViewModel = ReportsViewModel()
    @State private var showWeakPoints = false
    @State private var selectedFilter: ResumeFilter = .all
    @State private var showingShareSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Professional Header
                    professionalHeader

                    // Quick Stats Overview
                    quickStatsSection

                    // Filter Controls
                    filterControls

                    // Employment History
                    employmentHistorySection

                    // Performance Metrics
                    performanceMetricsSection

                    // Skills & Competencies
                    skillsSection

                    // Earnings History
                    earningsSection

                    // Verification Status
                    verificationStatusSection

                    // Verification Dashboard Link
                    verificationDashboardLink
                }
                .padding()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Professional Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
        }
        .onAppear {
            reportsViewModel.loadProfessionalData()
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [reportsViewModel.generatePDFReport()])
        }
    }

    // MARK: - Header Section

    private var professionalHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Joseph Dormond")
                        .font(Theme.Fonts.title)
                        .foregroundColor(Theme.Colors.text)

                    Text("Senior iOS Developer")
                        .font(Theme.Fonts.headline)
                        .foregroundColor(Theme.Colors.primary)

                    Text("5+ Years Experience • Verified Profile")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Verification Badge
                VStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title)
                        .foregroundColor(.green)
                    Text("Verified")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(.green)
                }
            }

            // Professional Summary
            Text(
                "Experienced iOS developer with proven track record in mobile app development, team leadership, and technical innovation. Demonstrated success in delivering high-quality applications and mentoring junior developers."
            )
            .font(Theme.Fonts.body)
            .foregroundColor(Theme.Colors.textSecondary)
            .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }

    // MARK: - Quick Stats

    private var quickStatsSection: some View {
        HStack(spacing: Theme.Spacing.medium) {
            StatCard(
                title: "Total Experience",
                value: "5.2 Years",
                icon: "clock.fill",
                color: .blue
            )

            StatCard(
                title: "Companies",
                value: "\(reportsViewModel.employmentHistory.count)",
                icon: "building.2.fill",
                color: .green
            )

            StatCard(
                title: "Avg. Rating",
                value: "4.8/5.0",
                icon: "star.fill",
                color: .orange
            )
        }
    }

    // MARK: - Filter Controls

    private var filterControls: some View {
        HStack(spacing: Theme.Spacing.small) {
            ForEach(ResumeFilter.allCases, id: \.self) { filter in
                Button(action: {
                    selectedFilter = filter
                }) {
                    Text(filter.displayName)
                        .font(Theme.Fonts.caption)
                        .padding(.horizontal, Theme.Spacing.medium)
                        .padding(.vertical, Theme.Spacing.small)
                        .background(
                            selectedFilter == filter ? Theme.Colors.primary : Theme.Colors.surface
                        )
                        .foregroundColor(selectedFilter == filter ? .white : Theme.Colors.text)
                        .cornerRadius(Theme.Spacing.small)
                }
            }

            Spacer()

            // Weak Points Toggle
            Toggle("Show Weak Points", isOn: $showWeakPoints)
                .toggleStyle(SwitchToggleStyle(tint: Theme.Colors.primary))
                .font(Theme.Fonts.caption)
        }
    }

    // MARK: - Employment History

    private var employmentHistorySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Text("Employment History")
                    .font(Theme.Fonts.headline)
                    .foregroundColor(Theme.Colors.text)

                Spacer()

                Text("HR Verified")
                    .font(Theme.Fonts.caption)
                    .foregroundColor(.green)
                    .padding(.horizontal, Theme.Spacing.small)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(Theme.Spacing.small)
            }

            ForEach(reportsViewModel.employmentHistory, id: \.id) { job in
                EmploymentCard(job: job, showWeakPoints: showWeakPoints)
            }
        }
    }

    // MARK: - Performance Metrics

    private var performanceMetricsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Performance Metrics")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: Theme.Spacing.medium
            ) {
                MetricCard(
                    title: "Leadership",
                    value: "4.9/5.0",
                    trend: "+0.3",
                    color: .blue
                )

                MetricCard(
                    title: "Technical Skills",
                    value: "4.8/5.0",
                    trend: "+0.2",
                    color: .green
                )

                MetricCard(
                    title: "Communication",
                    value: "4.7/5.0",
                    trend: "+0.1",
                    color: .orange
                )

                MetricCard(
                    title: "Problem Solving",
                    value: "4.9/5.0",
                    trend: "+0.4",
                    color: .purple
                )
            }
        }
    }

    // MARK: - Skills Section

    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Core Competencies")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: Theme.Spacing.small
            ) {
                ForEach(reportsViewModel.skills, id: \.name) { skill in
                    SkillTag(
                        name: skill.name,
                        level: skill.level,
                        isVerified: skill.isVerified
                    )
                }
            }
        }
    }

    // MARK: - Earnings Section

    private var earningsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Earnings History")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            ForEach(reportsViewModel.earningsHistory, id: \.year) { earning in
                EarningCard(earning: earning)
            }
        }
    }

    // MARK: - Verification Status

    private var verificationStatusSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Verification Status")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            VStack(spacing: Theme.Spacing.small) {
                VerificationRow(
                    item: "Employment History",
                    status: .approved,
                    date: "2024-01-15"
                )

                VerificationRow(
                    item: "Performance Metrics",
                    status: .approved,
                    date: "2024-01-15"
                )

                VerificationRow(
                    item: "Earnings Data",
                    status: .approved,
                    date: "2024-01-15"
                )

                VerificationRow(
                    item: "Skills Assessment",
                    status: .pending,
                    date: "In Progress"
                )

                VerificationRow(
                    item: "Identity Verification",
                    status: .approved,
                    date: "ClearMe Verified"
                )

                VerificationRow(
                    item: "Company Verification",
                    status: .approved,
                    date: "HR Verified"
                )
            }

            // Verification Dashboard Link
            NavigationLink(destination: VerificationDashboardView(userID: "current_user_id")) {
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                        Text("Verification Dashboard")
                            .font(Theme.Fonts.subheadline)
                            .foregroundColor(Theme.Colors.primary)

                        Text("Manage ClearMe integration and verification status")
                            .font(Theme.Fonts.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.Colors.primary)
                }
                .padding()
                .background(Theme.Colors.primary.opacity(0.1))
                .cornerRadius(Theme.Spacing.small)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct EmploymentCard: View {
    let job: EmploymentRecord
    let showWeakPoints: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text(job.companyName)
                        .font(Theme.Fonts.headline)
                        .foregroundColor(Theme.Colors.text)

                    Text(job.position)
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.primary)

                    Text("\(job.startDate) - \(job.endDate)")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: Theme.Spacing.small) {
                    Text("$\(job.hourlyRate)/hr")
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.text)

                    Text("Rating: \(job.rating)/5.0")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(.orange)
                }
            }

            // Key Responsibilities
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("Key Responsibilities:")
                    .font(Theme.Fonts.body)
                    .foregroundColor(Theme.Colors.text)

                ForEach(job.responsibilities, id: \.self) { responsibility in
                    HStack(alignment: .top) {
                        Text("•")
                            .foregroundColor(Theme.Colors.primary)
                        Text(responsibility)
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }

            // Performance Highlights
            if !job.achievements.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Key Achievements:")
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.text)

                    ForEach(job.achievements, id: \.self) { achievement in
                        HStack(alignment: .top) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(achievement)
                                .font(Theme.Fonts.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }
                }
            }

            // Weak Points (Conditional)
            if showWeakPoints && !job.weakPoints.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Areas for Improvement:")
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.text)

                    ForEach(job.weakPoints, id: \.self) { weakPoint in
                        HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text(weakPoint)
                                .font(Theme.Fonts.body)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }
                }
            }

            // Verification Badge
            HStack {
                Spacer()
                HStack(spacing: Theme.Spacing.small) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("HR Verified")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let trend: String
    let color: Color

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            Text(value)
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            Text(trend)
                .font(Theme.Fonts.caption)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct SkillTag: View {
    let name: String
    let level: String
    let isVerified: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.small) {
            Text(name)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.text)

            if isVerified {
                Image(systemName: "checkmark.seal.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, Theme.Spacing.small)
        .padding(.vertical, 4)
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.small)
    }
}

struct EarningCard: View {
    let earning: EarningRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text(earning.year)
                    .font(Theme.Fonts.body)
                    .foregroundColor(Theme.Colors.text)

                Text(earning.company)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Theme.Spacing.small) {
                Text("$\(earning.totalEarnings, specifier: "%.0f")")
                    .font(Theme.Fonts.headline)
                    .foregroundColor(Theme.Colors.primary)

                Text("$\(earning.hourlyRate)/hr")
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .background(Theme.Colors.surface)
        .cornerRadius(Theme.Spacing.medium)
    }
}

struct VerificationRow: View {
    let item: String
    let status: VerificationStatus
    let date: String

    var body: some View {
        HStack {
            Text(item)
                .font(Theme.Fonts.body)
                .foregroundColor(Theme.Colors.text)

            Spacer()

            HStack(spacing: Theme.Spacing.small) {
                Image(systemName: status.iconName)
                    .foregroundColor(status.color)

                Text(status.displayName)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(status.color)

                Text(date)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Supporting Types

enum ResumeFilter: CaseIterable {
    case all, recent, verified, highPerforming

    var displayName: String {
        switch self {
        case .all: return "All"
        case .recent: return "Recent"
        case .verified: return "Verified"
        case .highPerforming: return "Top Rated"
        }
    }
}

// Using the VerificationStatus enum from StryVr/Models/Enums/VerificationStatus.swift

// MARK: - Data Models

struct EmploymentRecord: Identifiable {
    let id = UUID()
    let companyName: String
    let position: String
    let startDate: String
    let endDate: String
    let hourlyRate: Int
    let rating: Double
    let responsibilities: [String]
    let achievements: [String]
    let weakPoints: [String]
}

struct SkillRecord: Identifiable {
    let id = UUID()
    let name: String
    let level: String
    let isVerified: Bool
}

struct EarningRecord: Identifiable {
    let id = UUID()
    let year: String
    let company: String
    let totalEarnings: Double
    let hourlyRate: Double
}

// MARK: - ViewModel

class ReportsViewModel: ObservableObject {
    @Published var employmentHistory: [EmploymentRecord] = []
    @Published var skills: [SkillRecord] = []
    @Published var earningsHistory: [EarningRecord] = []

    func loadProfessionalData() {
        // Load verified employment data
        employmentHistory = [
            EmploymentRecord(
                companyName: "TechCorp Inc.",
                position: "Senior iOS Developer",
                startDate: "2022-03",
                endDate: "2024-01",
                hourlyRate: 85,
                rating: 4.9,
                responsibilities: [
                    "Led development of flagship iOS app with 2M+ users",
                    "Mentored 3 junior developers and conducted code reviews",
                    "Implemented CI/CD pipeline reducing deployment time by 60%",
                    "Collaborated with design team on UI/UX improvements",
                ],
                achievements: [
                    "Increased app performance by 40% through optimization",
                    "Reduced crash rate by 80% through better error handling",
                    "Received 'Developer of the Year' award in 2023",
                ],
                weakPoints: [
                    "Could improve documentation practices",
                    "Sometimes takes on too many tasks simultaneously",
                ]
            ),
            EmploymentRecord(
                companyName: "StartupXYZ",
                position: "iOS Developer",
                startDate: "2020-06",
                endDate: "2022-02",
                hourlyRate: 65,
                rating: 4.7,
                responsibilities: [
                    "Developed and maintained 3 iOS applications",
                    "Worked closely with product managers on feature planning",
                    "Participated in agile development processes",
                    "Integrated third-party APIs and services",
                ],
                achievements: [
                    "Successfully launched app to App Store with 4.5-star rating",
                    "Implemented real-time chat feature used by 50K+ users",
                    "Reduced app size by 30% through optimization",
                ],
                weakPoints: [
                    "Initial code architecture could have been more scalable",
                    "Sometimes rushed features without proper testing",
                ]
            ),
        ]

        // Load skills data
        skills = [
            SkillRecord(name: "Swift", level: "Expert", isVerified: true),
            SkillRecord(name: "SwiftUI", level: "Advanced", isVerified: true),
            SkillRecord(name: "iOS Development", level: "Expert", isVerified: true),
            SkillRecord(name: "Git", level: "Advanced", isVerified: true),
            SkillRecord(name: "Firebase", level: "Intermediate", isVerified: false),
            SkillRecord(name: "Team Leadership", level: "Advanced", isVerified: true),
            SkillRecord(name: "Code Review", level: "Advanced", isVerified: true),
            SkillRecord(name: "Agile", level: "Intermediate", isVerified: false),
            SkillRecord(name: "UI/UX Design", level: "Intermediate", isVerified: false),
        ]

        // Load earnings data
        earningsHistory = [
            EarningRecord(
                year: "2023", company: "TechCorp Inc.", totalEarnings: 176800, hourlyRate: 85),
            EarningRecord(
                year: "2022", company: "TechCorp Inc.", totalEarnings: 88400, hourlyRate: 85),
            EarningRecord(
                year: "2021", company: "StartupXYZ", totalEarnings: 67600, hourlyRate: 65),
            EarningRecord(
                year: "2020", company: "StartupXYZ", totalEarnings: 33800, hourlyRate: 65),
        ]
    }

    func generatePDFReport() -> URL {
        // Generate PDF report for sharing
        // This would create a professional PDF version of the resume
        return URL(string: "stryvr://resume-pdf")!
    }
}

#Preview {
    ReportsView()
}
