//
//  CrossDepartmentalBridgeDashboard.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🌉 Revolutionary Cross-Departmental Bridge Dashboard - AI-Powered Gap Analysis & Collaboration
//  ⚡ Interactive Gap Visualization, Bridge Building & Organizational Harmony Tools
//

import SwiftUI

struct CrossDepartmentalBridgeDashboard: View {
    @StateObject private var bridgingService = CrossDepartmentalBridgingService.shared
    @State private var selectedTab: BridgeTab = .overview
    @State private var selectedGap: DepartmentGap?
    @State private var showingGapDetails = false
    @State private var showingCreateSession = false
    @State private var showingInsights = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with metrics
                bridgeMetricsHeader
                
                // Tab Navigation
                bridgeTabBar
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    OverviewTab()
                        .tag(BridgeTab.overview)
                    
                    GapsAnalysisTab()
                        .tag(BridgeTab.gaps)
                    
                    BridgeSessionsTab()
                        .tag(BridgeTab.sessions)
                    
                    CollaborationOpportunitiesTab()
                        .tag(BridgeTab.opportunities)
                    
                    InsightsTab()
                        .tag(BridgeTab.insights)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(Theme.Colors.backgroundPrimary)
            .navigationTitle("Department Bridges")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingGapDetails) {
                if let gap = selectedGap {
                    GapDetailView(gap: gap)
                }
            }
            .sheet(isPresented: $showingCreateSession) {
                CreateBridgeSessionView()
            }
            .onAppear {
                bridgingService.startDepartmentAnalysis()
            }
        }
        .environmentObject(bridgingService)
    }
    
    // MARK: - Bridge Metrics Header
    
    private var bridgeMetricsHeader: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack(spacing: Theme.Spacing.large) {
                // Total Gaps
                MetricCard(
                    title: "Gaps Detected",
                    value: "\(bridgingService.bridgeMetrics.totalGapsDetected)",
                    subtitle: "Active Issues",
                    color: Theme.Colors.neonOrange,
                    icon: "exclamationmark.triangle.fill"
                )
                
                // Success Rate
                MetricCard(
                    title: "Success Rate",
                    value: "\(Int(bridgingService.bridgeMetrics.successRate * 100))%",
                    subtitle: "Resolved",
                    color: Theme.Colors.neonGreen,
                    icon: "checkmark.circle.fill"
                )
                
                // Active Sessions
                MetricCard(
                    title: "Active Bridges",
                    value: "\(bridgingService.bridgeMetrics.activeInterventions)",
                    subtitle: "In Progress",
                    color: Theme.Colors.neonBlue,
                    icon: "arrow.triangle.merge"
                )
            }
            
            // Department Satisfaction Score
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title3)
                
                Text("Department Satisfaction")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(bridgingService.bridgeMetrics.departmentSatisfaction * 100))%")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonPink)
            }
            .padding()
            .applyLiquidGlassCard()
        }
        .padding()
    }
    
    // MARK: - Tab Bar
    
    private var bridgeTabBar: some View {
        HStack(spacing: 0) {
            ForEach(BridgeTab.allCases, id: \.self) { tab in
                BridgeTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Bridge Tabs

enum BridgeTab: String, CaseIterable {
    case overview = "Overview"
    case gaps = "Gaps"
    case sessions = "Sessions"
    case opportunities = "Opportunities"
    case insights = "Insights"
    
    var icon: String {
        switch self {
        case .overview: return "chart.bar.fill"
        case .gaps: return "exclamationmark.triangle.fill"
        case .sessions: return "arrow.triangle.merge"
        case .opportunities: return "lightbulb.fill"
        case .insights: return "brain.head.profile"
        }
    }
}

struct BridgeTabButton: View {
    let tab: BridgeTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
                
                Text(tab.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.Colors.neonBlue : Theme.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Theme.Colors.neonBlue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Overview Tab

struct OverviewTab: View {
    @EnvironmentObject private var bridgingService: CrossDepartmentalBridgingService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.large) {
                // Department Network Visualization
                departmentNetworkCard
                
                // Recent Bridge Activities
                recentActivitiesCard
                
                // Collaboration Heatmap
                collaborationHeatmapCard
                
                // Quick Actions
                quickActionsCard
            }
            .padding()
        }
    }
    
    private var departmentNetworkCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "network")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title2)
                
                Text("Department Network")
                    .font(Theme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("Live")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.neonGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.neonGreen.opacity(0.2), in: Capsule())
            }
            
            DepartmentNetworkView(departments: Department.allCases)
        }
        .padding()
        .applyLiquidGlassCard()
    }
    
    private var recentActivitiesCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title3)
                
                Text("Recent Bridge Activities")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(bridgingService.activeBridgingSessions.prefix(3)) { session in
                    BridgeActivityRow(session: session)
                }
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
    
    private var collaborationHeatmapCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title3)
                
                Text("Collaboration Heatmap")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("+35%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonGreen)
            }
            
            CollaborationHeatmapView()
        }
        .padding()
        .applyLiquidGlassCard()
    }
    
    private var quickActionsCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Quick Actions")
                .font(Theme.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                QuickActionButton(
                    title: "Create Bridge",
                    icon: "plus.circle.fill",
                    color: Theme.Colors.neonBlue,
                    action: { /* Create bridge action */ }
                )
                
                QuickActionButton(
                    title: "Schedule Session",
                    icon: "calendar.badge.plus",
                    color: Theme.Colors.neonGreen,
                    action: { /* Schedule session action */ }
                )
                
                QuickActionButton(
                    title: "Analyze Gaps",
                    icon: "magnifyingglass.circle.fill",
                    color: Theme.Colors.neonOrange,
                    action: { /* Analyze gaps action */ }
                )
                
                QuickActionButton(
                    title: "View Reports",
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    color: Theme.Colors.neonPink,
                    action: { /* View reports action */ }
                )
            }
        }
        .padding()
        .applyLiquidGlassCard()
    }
}

// MARK: - Gaps Analysis Tab

struct GapsAnalysisTab: View {
    @EnvironmentObject private var bridgingService: CrossDepartmentalBridgingService
    @State private var selectedGap: DepartmentGap?
    @State private var showingGapDetails = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(bridgingService.detectedGaps) { gap in
                    GapAnalysisCard(gap: gap) {
                        selectedGap = gap
                        showingGapDetails = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingGapDetails) {
            if let gap = selectedGap {
                GapDetailView(gap: gap)
            }
        }
    }
}

// MARK: - Bridge Sessions Tab

struct BridgeSessionsTab: View {
    @EnvironmentObject private var bridgingService: CrossDepartmentalBridgingService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(bridgingService.activeBridgingSessions) { session in
                    BridgeSessionCard(session: session)
                }
            }
            .padding()
        }
    }
}

// MARK: - Collaboration Opportunities Tab

struct CollaborationOpportunitiesTab: View {
    @EnvironmentObject private var bridgingService: CrossDepartmentalBridgingService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(bridgingService.collaborationOpportunities) { opportunity in
                    CollaborationOpportunityCard(opportunity: opportunity)
                }
            }
            .padding()
        }
    }
}

// MARK: - Insights Tab

struct InsightsTab: View {
    @EnvironmentObject private var bridgingService: CrossDepartmentalBridgingService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                ForEach(bridgingService.departmentInsights) { insight in
                    InsightCard(insight: insight)
                }
            }
            .padding()
        }
    }
}

// MARK: - Metric Card

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .neonGlow(color: color, pulse: true)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: color, radius: 8, intensity: 0.6)
    }
}

// MARK: - Department Network View

struct DepartmentNetworkView: View {
    let departments: [Department]
    @State private var networkLayout: [DepartmentNode] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Connection lines
                ForEach(networkLayout, id: \.department) { node in
                    ForEach(node.connections, id: \.self) { connectionIndex in
                        if connectionIndex < networkLayout.count {
                            let targetNode = networkLayout[connectionIndex]
                            Path { path in
                                path.move(to: node.position)
                                path.addLine(to: targetNode.position)
                            }
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Theme.Colors.fromString(node.department.color).opacity(0.6),
                                        Theme.Colors.fromString(targetNode.department.color).opacity(0.6)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                        }
                    }
                }
                
                // Department nodes
                ForEach(networkLayout, id: \.department) { node in
                    DepartmentNodeView(department: node.department)
                        .position(node.position)
                }
            }
        }
        .frame(height: 200)
        .onAppear {
            generateNetworkLayout()
        }
    }
    
    private func generateNetworkLayout() {
        let center = CGPoint(x: 200, y: 100)
        let radius: CGFloat = 80
        
        networkLayout = departments.enumerated().map { index, department in
            let angle = Double(index) * (2 * .pi / Double(departments.count))
            let position = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            // Generate some random connections
            let connections = (0..<departments.count).filter { $0 != index && Bool.random() }
            
            return DepartmentNode(
                department: department,
                position: position,
                connections: connections
            )
        }
    }
}

struct DepartmentNode {
    let department: Department
    let position: CGPoint
    let connections: [Int]
}

struct DepartmentNodeView: View {
    let department: Department
    @State private var pulsing = false
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Theme.Colors.fromString(department.color).opacity(0.3))
                    .frame(width: 40, height: 40)
                    .scaleEffect(pulsing ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulsing)
                
                Image(systemName: department.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.Colors.fromString(department.color))
            }
            
            Text(department.displayName)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .onAppear {
            pulsing = true
        }
    }
}

// MARK: - Collaboration Heatmap View

struct CollaborationHeatmapView: View {
    let departments = Department.allCases
    
    var body: some View {
        VStack(spacing: 8) {
            // Header row
            HStack(spacing: 4) {
                Text("")
                    .font(.caption2)
                    .frame(width: 40, alignment: .leading)
                
                ForEach(departments, id: \.self) { dept in
                    Text(String(dept.displayName.prefix(3)))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .frame(width: 35)
                }
            }
            
            // Data rows
            ForEach(departments, id: \.self) { rowDept in
                HStack(spacing: 4) {
                    Text(String(rowDept.displayName.prefix(3)))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .frame(width: 40, alignment: .leading)
                    
                    ForEach(departments, id: \.self) { colDept in
                        CollaborationCell(
                            intensity: getCollaborationIntensity(rowDept, colDept),
                            isDiagonal: rowDept == colDept
                        )
                    }
                }
            }
        }
    }
    
    private func getCollaborationIntensity(_ dept1: Department, _ dept2: Department) -> Double {
        if dept1 == dept2 { return 1.0 }
        
        // Simulate collaboration intensity based on department types
        let collaborationMatrix: [Department: [Department: Double]] = [
            .engineering: [.design: 0.8, .marketing: 0.4, .sales: 0.3, .hr: 0.5],
            .design: [.engineering: 0.8, .marketing: 0.9, .sales: 0.6, .hr: 0.4],
            .marketing: [.engineering: 0.4, .design: 0.9, .sales: 0.7, .hr: 0.6],
            .sales: [.engineering: 0.3, .design: 0.6, .marketing: 0.7, .hr: 0.5],
            .hr: [.engineering: 0.5, .design: 0.4, .marketing: 0.6, .sales: 0.5]
        ]
        
        return collaborationMatrix[dept1]?[dept2] ?? 0.3
    }
}

struct CollaborationCell: View {
    let intensity: Double
    let isDiagonal: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                isDiagonal ? 
                Color.clear :
                Theme.Colors.neonBlue.opacity(intensity)
            )
            .frame(width: 35, height: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        isDiagonal ? 
                        Theme.Colors.textTertiary.opacity(0.3) :
                        Color.clear,
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
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
                    .neonGlow(color: color, pulse: true)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Gap Analysis Card

struct GapAnalysisCard: View {
    let gap: DepartmentGap
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                HStack {
                    // Gap severity indicator
                    Circle()
                        .fill(Theme.Colors.fromString(gap.severity.color))
                        .frame(width: 12, height: 12)
                        .neonGlow(color: Theme.Colors.fromString(gap.severity.color), pulse: true)
                    
                    Text(gap.type.displayName)
                        .font(Theme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(gap.severity)".capitalized)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.fromString(gap.severity.color))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.Colors.fromString(gap.severity.color).opacity(0.2), in: Capsule())
                }
                
                Text(gap.description)
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    ForEach(gap.departments, id: \.self) { department in
                        DepartmentChip(department: department)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textTertiary)
                }
            }
            .padding()
            .applyLiquidGlassCard()
            .liquidGlassGlow(color: Theme.Colors.fromString(gap.severity.color), radius: 8, intensity: 0.4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension GapType {
    var displayName: String {
        switch self {
        case .communicationBarrier: return "Communication Barrier"
        case .skillGap: return "Skill Gap"
        case .processAlignment: return "Process Misalignment"
        case .culturalMismatch: return "Cultural Mismatch"
        }
    }
}

// MARK: - Department Chip

struct DepartmentChip: View {
    let department: Department
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: department.icon)
                .font(.caption2)
                .foregroundColor(Theme.Colors.fromString(department.color))
            
            Text(department.displayName)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(Theme.Colors.fromString(department.color))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.Colors.fromString(department.color).opacity(0.2), in: Capsule())
    }
}

// MARK: - Bridge Activity Row

struct BridgeActivityRow: View {
    let session: BridgingSession
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .neonGlow(color: statusColor, pulse: session.status == .inProgress)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Bridge Session - \(session.gap.type.displayName)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text("Facilitator: \(session.facilitator)")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            Text(session.status.displayName)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(statusColor)
        }
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch session.status {
        case .scheduled: return Theme.Colors.neonBlue
        case .inProgress: return Theme.Colors.neonYellow
        case .completed: return Theme.Colors.neonGreen
        case .cancelled: return Theme.Colors.neonRed
        }
    }
}

extension SessionStatus {
    var displayName: String {
        switch self {
        case .scheduled: return "Scheduled"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
}

// MARK: - Bridge Session Card

struct BridgeSessionCard: View {
    let session: BridgingSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "arrow.triangle.merge")
                    .foregroundColor(Theme.Colors.neonBlue)
                    .font(.title3)
                
                Text("Bridge Session")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text(session.status.displayName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2), in: Capsule())
            }
            
            Text(session.gap.description)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Participants: \(session.participants.count)")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text("Facilitator: \(session.facilitator)")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text("Scheduled: \(session.scheduledDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: statusColor, radius: 8, intensity: 0.4)
    }
    
    private var statusColor: Color {
        switch session.status {
        case .scheduled: return Theme.Colors.neonBlue
        case .inProgress: return Theme.Colors.neonYellow
        case .completed: return Theme.Colors.neonGreen
        case .cancelled: return Theme.Colors.neonRed
        }
    }
}

// MARK: - Collaboration Opportunity Card

struct CollaborationOpportunityCard: View {
    let opportunity: CollaborationOpportunity
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title3)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)
                
                Text("Collaboration Opportunity")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(opportunity.synergyScore * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.neonYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.neonYellow.opacity(0.2), in: Capsule())
            }
            
            HStack {
                ForEach(opportunity.departments, id: \.self) { department in
                    DepartmentChip(department: department)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Value")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                    
                    Text("$\(Int(opportunity.estimatedValue / 1000))K")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonGreen)
                }
            }
            
            Text("Potential Projects:")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ForEach(opportunity.potentialProjects.prefix(3), id: \.self) { project in
                Text("• \(project)")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: Theme.Colors.neonYellow, radius: 8, intensity: 0.4)
    }
}

// MARK: - Insight Card

struct InsightCard: View {
    let insight: DepartmentInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: insightIcon)
                    .foregroundColor(insightColor)
                    .font(.title3)
                
                Text(insight.title)
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text(insight.priority.displayName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(priorityColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.2), in: Capsule())
            }
            
            Text(insight.description)
                .font(Theme.Typography.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(nil)
            
            if !insight.recommendedActions.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended Actions:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    ForEach(insight.recommendedActions.prefix(3), id: \.self) { action in
                        Text("• \(action)")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
            
            HStack {
                ForEach(insight.affectedDepartments, id: \.self) { department in
                    DepartmentChip(department: department)
                }
                
                Spacer()
                
                Text(insight.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textTertiary)
            }
        }
        .padding()
        .applyLiquidGlassCard()
        .liquidGlassGlow(color: insightColor, radius: 8, intensity: 0.4)
    }
    
    private var insightIcon: String {
        switch insight.type {
        case .gapIdentified: return "exclamationmark.triangle.fill"
        case .collaborationOpportunity: return "lightbulb.fill"
        case .successStory: return "star.fill"
        case .improvementSuggestion: return "arrow.up.circle.fill"
        }
    }
    
    private var insightColor: Color {
        switch insight.type {
        case .gapIdentified: return Theme.Colors.neonOrange
        case .collaborationOpportunity: return Theme.Colors.neonYellow
        case .successStory: return Theme.Colors.neonGreen
        case .improvementSuggestion: return Theme.Colors.neonBlue
        }
    }
    
    private var priorityColor: Color {
        switch insight.priority {
        case .low: return Theme.Colors.neonGreen
        case .medium: return Theme.Colors.neonYellow
        case .high: return Theme.Colors.neonOrange
        case .urgent: return Theme.Colors.neonRed
        }
    }
}

extension Priority {
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
}

// MARK: - Gap Detail View

struct GapDetailView: View {
    let gap: DepartmentGap
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.large) {
                    // Gap header
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        HStack {
                            Circle()
                                .fill(Theme.Colors.fromString(gap.severity.color))
                                .frame(width: 16, height: 16)
                                .neonGlow(color: Theme.Colors.fromString(gap.severity.color), pulse: true)
                            
                            Text(gap.type.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.Colors.textPrimary)
                            
                            Spacer()
                            
                            Text("\(gap.severity)".capitalized)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.Colors.fromString(gap.severity.color))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Theme.Colors.fromString(gap.severity.color).opacity(0.2), in: Capsule())
                        }
                        
                        Text(gap.description)
                            .font(.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .padding()
                    .applyLiquidGlassCard()
                    
                    // Affected departments
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Affected Departments")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(gap.departments, id: \.self) { department in
                                DepartmentDetailCard(department: department)
                            }
                        }
                    }
                    .padding()
                    .applyLiquidGlassCard()
                    
                    // Business impact
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Business Impact")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        BusinessImpactView(impact: gap.impact)
                    }
                    .padding()
                    .applyLiquidGlassCard()
                    
                    // Suggested interventions
                    VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                        Text("Suggested Interventions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(gap.suggestedInterventions, id: \.self) { intervention in
                                InterventionRow(intervention: intervention)
                            }
                        }
                    }
                    .padding()
                    .applyLiquidGlassCard()
                }
                .padding()
            }
            .navigationTitle("Gap Analysis")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Department Detail Card

struct DepartmentDetailCard: View {
    let department: Department
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: department.icon)
                .font(.title2)
                .foregroundColor(Theme.Colors.fromString(department.color))
                .neonGlow(color: Theme.Colors.fromString(department.color), pulse: true)
            
            Text(department.displayName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.Colors.fromString(department.color).opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - Business Impact View

struct BusinessImpactView: View {
    let impact: BusinessImpact
    
    var body: some View {
        VStack(spacing: 12) {
            ImpactMetricRow(
                title: "Productivity Loss",
                value: impact.productivityLoss,
                color: Theme.Colors.neonOrange,
                icon: "chart.line.downtrend.xyaxis"
            )
            
            ImpactMetricRow(
                title: "Innovation Reduction",
                value: impact.innovationReduction,
                color: Theme.Colors.neonRed,
                icon: "lightbulb.slash"
            )
            
            ImpactMetricRow(
                title: "Employee Satisfaction",
                value: impact.employeeSatisfaction,
                color: Theme.Colors.neonGreen,
                icon: "heart.fill"
            )
            
            ImpactMetricRow(
                title: "Customer Impact",
                value: impact.customerImpact,
                color: Theme.Colors.neonBlue,
                icon: "person.fill"
            )
        }
    }
}

struct ImpactMetricRow: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.body)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Spacer()
            
            Text("\(Int(value * 100))%")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

// MARK: - Intervention Row

struct InterventionRow: View {
    let intervention: InterventionType
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.Colors.neonGreen)
                .font(.body)
            
            Text(intervention.displayName)
                .font(.body)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Create Bridge Session View

struct CreateBridgeSessionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Bridge Session")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Spacer()
                
                Text("Coming Soon")
                    .font(.body)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.Colors.neonBlue)
                }
            }
        }
    }
}

#Preview {
    CrossDepartmentalBridgeDashboard()
}
