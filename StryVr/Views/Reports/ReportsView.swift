//
//  ReportsView.swift
//  StryVr
//
//  📊 Verified Professional Resume View – HR-Trusted Employment History
//  Shows verified past jobs, earnings, performance metrics, and professional achievements
//  🌟 iOS 18 Liquid Glass Implementation
//

import SwiftUI

struct ReportsView: View {
    @StateObject private var reportsViewModel = ReportsViewModel()
    @EnvironmentObject var router: AppRouter
    @State private var showWeakPoints = false
    @State private var selectedFilter: ResumeFilter = .all
    @State private var showingShareSheet = false
    @Namespace private var glassNamespace

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.large) {
                // Professional Header with new styling
                professionalHeader

                // Quick Actions Row
                quickActionsRow

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

                // AI Insights Link
                aiInsightsLink
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Theme.Colors.deepNavyBlue, Theme.Colors.subtleLightGray],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .navigationTitle("Reports")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingShareSheet = true
                    } label: {
                        Label("Share Report", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        router.navigate(to: .exportReport(reportId: "current_report", format: .pdf))
                    } label: {
                        Label("Export PDF", systemImage: "doc.fill")
                    }
                    
                    Button {
                        router.navigate(to: .reportShare(reportId: "current_report"))
                    } label: {
                        Label("Generate Link", systemImage: "link")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                .liquidGlassButton()
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
                    if #available(iOS 18.0, *) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundColor(.green)
                            .glassEffect(.regular.tint(.green.opacity(0.3)), in: Circle())
                            .glassEffectID("verification-badge", in: glassNamespace)
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    }

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
        .applyLiquidGlassCard()
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
                        .applyFilterButtonStyle(isSelected: selectedFilter == filter)
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
                    .applyVerificationBadgeStyle()
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
                    item: "Skills Assessment",
                    status: .pending,
                    date: "2024-01-20"
                )

                VerificationRow(
                    item: "Background Check",
                    status: .approved,
                    date: "2024-01-10"
                )
            }
        }
    }

    // MARK: - Verification Dashboard Link

    private var verificationDashboardLink: some View {
        NavigationLink(destination: VerificationDashboardView()) {
            HStack {
                Image(systemName: "shield.checkered")
                    .foregroundColor(Theme.Colors.primary)

                Text("Verification Dashboard")
                    .font(Theme.Fonts.body)
                    .foregroundColor(Theme.Colors.text)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding()
            .applyInteractiveLiquidGlassCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply iOS 18 Liquid Glass card with fallback
    func applyLiquidGlassCard() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular, in: RoundedRectangle(cornerRadius: Theme.Spacing.medium))
        } else {
            return self.background(Theme.Colors.surface)
                .cornerRadius(Theme.Spacing.medium)
        }
    }

    /// Apply iOS 18 Interactive Liquid Glass card with fallback
    func applyInteractiveLiquidGlassCard() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular.interactive(), in: RoundedRectangle(cornerRadius: Theme.Spacing.medium))
        } else {
            return self.background(Theme.Colors.surface)
                .cornerRadius(Theme.Spacing.medium)
        }
    }

    /// Apply filter button style with iOS 18 Liquid Glass
    func applyFilterButtonStyle(isSelected: Bool) -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                isSelected ? .regular.tint(Theme.Colors.primary.opacity(0.3)) : .regular,
                in: RoundedRectangle(cornerRadius: Theme.Spacing.small)
            )
            .foregroundColor(isSelected ? .white : Theme.Colors.text)
        } else {
            return self.background(
                isSelected ? Theme.Colors.primary : Theme.Colors.surface
            )
            .foregroundColor(isSelected ? .white : Theme.Colors.text)
            .cornerRadius(Theme.Spacing.small)
        }
    }

    /// Apply verification badge style with iOS 18 Liquid Glass
    func applyVerificationBadgeStyle() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(
                .regular.tint(.green.opacity(0.1)),
                in: RoundedRectangle(cornerRadius: Theme.Spacing.small))
        } else {
            return self.background(Color.green.opacity(0.1))
                .cornerRadius(Theme.Spacing.small)
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @Namespace private var glassNamespace

    var body: some View {
        VStack(spacing: Theme.Spacing.small) {
            if #available(iOS 18.0, *) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .glassEffect(.regular.tint(color.opacity(0.3)), in: Circle())
                    .glassEffectID("stat-icon-\(title)", in: glassNamespace)
            } else {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }

            Text(value)
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let trend: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            Text(value)
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.text)

            HStack {
                Text(trend)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(.green)

                Spacer()
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

struct SkillTag: View {
    let name: String
    let level: Int
    let isVerified: Bool

    var body: some View {
        HStack {
            Text(name)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.text)

            Spacer()

            if isVerified {
                if #available(iOS 18.0, *) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                        .glassEffect(.regular.tint(.green.opacity(0.3)), in: Circle())
                } else {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.small)
        .padding(.vertical, 4)
        .applyLiquidGlassCard()
    }
}

struct EarningCard: View {
    let earning: EarningHistory

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                Text("\(earning.year)")
                    .font(Theme.Fonts.headline)
                    .foregroundColor(Theme.Colors.text)

                Text(earning.company)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Text("$\(earning.amount, specifier: "%.0f")")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.primary)
        }
        .padding()
        .applyLiquidGlassCard()
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

            Text(date)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)

            if #available(iOS 18.0, *) {
                Image(systemName: status.icon)
                    .foregroundColor(status.color)
                    .glassEffect(.regular.tint(status.color.opacity(0.3)), in: Circle())
            } else {
                Image(systemName: status.icon)
                    .foregroundColor(status.color)
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

struct EmploymentCard: View {
    let job: EmploymentHistory
    let showWeakPoints: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text(job.title)
                        .font(Theme.Fonts.headline)
                        .foregroundColor(Theme.Colors.text)

                    Text(job.company)
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.primary)

                    Text("\(job.startDate) - \(job.endDate)")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Text("$\(job.salary, specifier: "%.0f")")
                    .font(Theme.Fonts.headline)
                    .foregroundColor(Theme.Colors.primary)
            }

            if showWeakPoints && !job.weakPoints.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Areas for Improvement:")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    ForEach(job.weakPoints, id: \.self) { point in
                        Text("• \(point)")
                            .font(Theme.Fonts.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

// MARK: - Supporting Types

enum ResumeFilter: CaseIterable {
    case all, recent, verified

    var displayName: String {
        switch self {
        case .all: return "All"
        case .recent: return "Recent"
        case .verified: return "Verified"
        }
    }
}

// VerificationStatus enum moved to StryVr/Models/Enums/VerificationStatus.swift

struct EarningHistory {
    let year: Int
    let company: String
    let amount: Double
}

struct EmploymentHistory {
    let id = UUID()
    let title: String
    let company: String
    let startDate: String
    let endDate: String
    let salary: Double
    let weakPoints: [String]
}

struct Skill {
    let name: String
    let level: Int
    let isVerified: Bool
}

class ReportsViewModel: ObservableObject {
    @Published var employmentHistory: [EmploymentHistory] = []
    @Published var skills: [Skill] = []
    @Published var earningsHistory: [EarningHistory] = []

    func loadProfessionalData() {
        // Load data from backend
        employmentHistory = [
            EmploymentHistory(
                title: "Senior iOS Developer",
                company: "TechCorp",
                startDate: "2022-01",
                endDate: "2024-01",
                salary: 120000,
                weakPoints: ["Public speaking", "Project management"]
            ),
            EmploymentHistory(
                title: "iOS Developer",
                company: "StartupXYZ",
                startDate: "2020-03",
                endDate: "2022-01",
                salary: 95000,
                weakPoints: ["Team leadership"]
            ),
        ]

        skills = [
            Skill(name: "Swift", level: 5, isVerified: true),
            Skill(name: "SwiftUI", level: 4, isVerified: true),
            Skill(name: "Firebase", level: 4, isVerified: false),
            Skill(name: "Git", level: 5, isVerified: true),
            Skill(name: "Agile", level: 3, isVerified: false),
            Skill(name: "UI/UX", level: 4, isVerified: true),
        ]

        earningsHistory = [
            EarningHistory(year: 2024, company: "TechCorp", amount: 120000),
            EarningHistory(year: 2023, company: "TechCorp", amount: 115000),
            EarningHistory(year: 2022, company: "StartupXYZ", amount: 95000),
            EarningHistory(year: 2021, company: "StartupXYZ", amount: 90000),
        ]
    }

    func generatePDFReport() -> String {
        // Generate PDF report
        return "Professional Report"
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct VerificationDashboardView: View {
    var body: some View {
        Text("Verification Dashboard")
            .navigationTitle("Verification")
    }
}

    // MARK: - Quick Actions Row
    
    private var quickActionsRow: some View {
        HStack(spacing: 16) {
            ActionButton(
                title: "Analytics",
                icon: "chart.line.uptrend.xyaxis",
                color: Theme.Colors.neonBlue
            ) {
                router.navigateToAnalytics(userId: "current_user")
            }
            
            ActionButton(
                title: "AI Insights",
                icon: "brain.head.profile",
                color: Theme.Colors.neonGreen
            ) {
                router.navigateToAIInsights(userId: "current_user")
            }
            
            ActionButton(
                title: "Export",
                icon: "square.and.arrow.up",
                color: Theme.Colors.neonOrange
            ) {
                showingShareSheet = true
            }
        }
    }
    
    // MARK: - AI Insights Link
    
    private var aiInsightsLink: some View {
        Button {
            router.navigateToAIInsights(userId: "current_user")
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "brain.head.profile.fill")
                            .foregroundColor(Theme.Colors.neonGreen)
                        
                        Text("AI-Powered Insights")
                            .font(Theme.Typography.headline)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    Text("Get personalized career recommendations based on your performance data")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
        }
        .liquidGlassCard()
        .neonGlow(color: Theme.Colors.neonGreen.opacity(0.3))
    }
}

// MARK: - Action Button Component

private struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .liquidGlassCard()
        .neonGlow(color: color.opacity(0.3))
    }
}

#Preview {
    ReportsView()
        .environmentObject(AppRouter())
}
