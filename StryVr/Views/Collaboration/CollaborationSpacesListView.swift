//
//  CollaborationSpacesListView.swift
//  StryVr
//
//  Created by Joseph Dormond on 1/15/25.
//  🌐 Revolutionary Collaboration Spaces Hub - AI-Powered Team Matching
//  🎯 Discover, Join, and Create Virtual Workspaces for Maximum Impact
//

import SwiftUI

struct CollaborationSpacesListView: View {
    @StateObject private var viewModel = CollaborationSpacesViewModel()
    @State private var selectedCategory: SpaceCategory = .all
    @State private var showingCreateSpace = false
    @State private var showingSpaceDetail = false
    @State private var selectedSpace: CollaborationSpace?
    @State private var searchText = ""
    @Namespace private var spacesNamespace

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.LiquidGlass.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search and filters
                    searchAndFiltersSection

                    // AI recommendations
                    if !viewModel.aiRecommendations.isEmpty {
                        aiRecommendationsSection
                    }

                    // Category filters
                    categoryFiltersSection

                    // Spaces list
                    spacesListSection
                }
            }
            .navigationTitle("Collaboration Spaces")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateSpace = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.neonBlue)
                            .font(.title2)
                            .neonGlow(color: Theme.Colors.neonBlue, pulse: true)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search spaces...")
        .sheet(isPresented: $showingCreateSpace) {
            CreateCollaborationSpaceView()
        }
        .sheet(isPresented: $showingSpaceDetail) {
            if let space = selectedSpace {
                CollaborationSpaceView(space: space)
            }
        }
        .onAppear {
            viewModel.loadSpaces()
        }
        .onChange(of: searchText) { newValue in
            viewModel.filterSpaces(by: newValue, category: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue in
            viewModel.filterSpaces(by: searchText, category: newValue)
        }
    }

    // MARK: - Search and Filters
    private var searchAndFiltersSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Quick stats header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Collaboration")
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("\(viewModel.totalSpaces) spaces • \(viewModel.totalMembers) members")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                // Live activity indicator
                if viewModel.hasLiveActivity {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Theme.Colors.neonGreen)
                            .frame(width: 8, height: 8)
                            .neonGlow(color: Theme.Colors.neonGreen, pulse: true)

                        Text("\(viewModel.liveActivityCount) active")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.neonGreen)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.large)
        .padding(.top, Theme.Spacing.medium)
    }

    // MARK: - AI Recommendations
    private var aiRecommendationsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(Theme.Colors.neonPink)
                    .font(.title2)
                    .neonGlow(color: Theme.Colors.neonPink, pulse: true)

                Text("AI Recommendations")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Button("Refresh") {
                    viewModel.refreshRecommendations()
                }
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.neonPink)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Theme.Spacing.medium) {
                    ForEach(viewModel.aiRecommendations) { recommendation in
                        AIRecommendationCard(recommendation: recommendation) {
                            handleRecommendation(recommendation)
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
        }
        .padding(.vertical, Theme.Spacing.medium)
        .background(Theme.Colors.glassPrimary.opacity(0.5))
    }

    // MARK: - Category Filters
    private var categoryFiltersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.medium) {
                ForEach(SpaceCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        category: category,
                        isSelected: selectedCategory == category,
                        count: viewModel.getCategoryCount(category),
                        action: {
                            withAnimation(.spring()) {
                                selectedCategory = category
                            }
                        }
                    )
                    .matchedGeometryEffect(id: "category-\(category.rawValue)", in: spacesNamespace)
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
        }
        .padding(.vertical, Theme.Spacing.medium)
    }

    // MARK: - Spaces List
    private var spacesListSection: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.medium) {
                // Featured spaces
                if selectedCategory == .all && !viewModel.featuredSpaces.isEmpty {
                    featuredSpacesSection
                }

                // Regular spaces
                ForEach(viewModel.filteredSpaces) { space in
                    CollaborationSpaceCard(space: space) {
                        selectedSpace = space
                        showingSpaceDetail = true
                    }
                    .matchedGeometryEffect(id: "space-\(space.id)", in: spacesNamespace)
                }

                // Create space prompt
                if viewModel.filteredSpaces.isEmpty && searchText.isEmpty {
                    createSpacePromptSection
                }

                // Empty search results
                if viewModel.filteredSpaces.isEmpty && !searchText.isEmpty {
                    emptySearchSection
                }
            }
            .padding(.horizontal, Theme.Spacing.large)
            .padding(.bottom, Theme.Spacing.xLarge)
        }
    }

    private var featuredSpacesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(Theme.Colors.neonYellow)
                    .font(.title3)
                    .neonGlow(color: Theme.Colors.neonYellow, pulse: true)

                Text("Featured Spaces")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()
            }

            ForEach(viewModel.featuredSpaces) { space in
                FeaturedSpaceCard(space: space) {
                    selectedSpace = space
                    showingSpaceDetail = true
                }
            }
        }
        .padding(.bottom, Theme.Spacing.large)
    }

    private var createSpacePromptSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 60))
                .foregroundColor(Theme.Colors.textTertiary)

            VStack(spacing: 8) {
                Text("Create Your First Space")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(
                    "Build a collaborative environment where your team can share skills and bridge gaps together"
                )
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
            }

            Button(action: {
                showingCreateSpace = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)

                    Text("Create Space")
                        .font(Theme.Typography.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal, Theme.Spacing.large)
                .padding(.vertical, Theme.Spacing.medium)
                .background(Theme.Colors.neonBlue.opacity(0.8), in: Capsule())
                .liquidGlassGlow(color: Theme.Colors.neonBlue, radius: 12)
            }
        }
        .padding(.vertical, Theme.Spacing.xLarge)
        .frame(maxWidth: .infinity)
    }

    private var emptySearchSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(Theme.Colors.textTertiary)

            VStack(spacing: 8) {
                Text("No spaces found")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text("Try adjusting your search or creating a new space")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button("Create Space") {
                showingCreateSpace = true
            }
            .font(Theme.Typography.caption)
            .foregroundColor(Theme.Colors.neonBlue)
        }
        .padding(.vertical, Theme.Spacing.xLarge)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Helper Methods

    private func handleRecommendation(_ recommendation: AISpaceRecommendation) {
        switch recommendation.type {
        case .join:
            if let spaceId = recommendation.targetSpaceId {
                viewModel.joinSpace(spaceId)
            }
        case .create:
            showingCreateSpace = true
        case .skillMatch:
            // Handle skill matching
            break
        }

        HapticManager.shared.impact(.medium)
    }
}

// MARK: - Supporting Views

struct AIRecommendationCard: View {
    let recommendation: AISpaceRecommendation
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                HStack {
                    Image(systemName: recommendation.type.icon)
                        .foregroundColor(recommendation.type.color)
                        .font(.title3)
                        .neonGlow(color: recommendation.type.color, pulse: true)

                    Spacer()

                    Text("AI")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Colors.neonPink)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.Colors.neonPink.opacity(0.2), in: Capsule())
                }

                Text(recommendation.title)
                    .font(Theme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.leading)

                Text(recommendation.description)
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                HStack {
                    Text(recommendation.type.actionText)
                        .font(.caption2)
                        .foregroundColor(recommendation.type.color)
                        .fontWeight(.medium)

                    Spacer()

                    Text("Confidence: \(Int(recommendation.confidence * 100))%")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textTertiary)
                }
            }
            .padding()
            .frame(width: 220)
            .background(Theme.Colors.glassPrimary, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(recommendation.type.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryFilterButton: View {
    let category: SpaceCategory
    let isSelected: Bool
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                    .foregroundColor(isSelected ? category.color : Theme.Colors.textSecondary)

                Text(category.title)
                    .font(Theme.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundColor(
                        isSelected ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)

                if !count.isZero {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : Theme.Colors.textTertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            isSelected ? category.color : Theme.Colors.textTertiary.opacity(0.3),
                            in: Capsule()
                        )
                }
            }
            .padding(.horizontal, Theme.Spacing.medium)
            .padding(.vertical, Theme.Spacing.small)
            .background(
                isSelected ? category.color.opacity(0.2) : Theme.Colors.glassPrimary,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? category.color : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CollaborationSpaceCard: View {
    let space: CollaborationSpace
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                // Header
                HStack {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(space.color.opacity(0.3))
                                .frame(width: 50, height: 50)

                            Image(systemName: space.icon)
                                .foregroundColor(space.color)
                                .font(.title3)
                                .neonGlow(color: space.color, pulse: true)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(space.name)
                                .font(Theme.Typography.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Text("\(space.activeMembers) members")
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }

                    Spacer()

                    // Join status
                    if space.isUserMember {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Theme.Colors.neonGreen)
                                .frame(width: 8, height: 8)

                            Text("Joined")
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.neonGreen)
                                .fontWeight(.semibold)
                        }
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.Colors.textTertiary)
                            .font(.caption)
                    }
                }

                // Skills preview
                if !space.skillsBeingShared.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Skills")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .fontWeight(.semibold)

                        FlowLayout(spacing: 6) {
                            ForEach(space.skillsBeingShared.prefix(6), id: \.self) { skill in
                                Text(skill)
                                    .font(.caption2)
                                    .foregroundColor(space.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(space.color.opacity(0.2), in: Capsule())
                            }

                            if space.skillsBeingShared.count > 6 {
                                Text("+\(space.skillsBeingShared.count - 6)")
                                    .font(.caption2)
                                    .foregroundColor(Theme.Colors.textTertiary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.Colors.glassPrimary, in: Capsule())
                            }
                        }
                    }
                }

                // Activity indicator
                if space.hasRecentActivity {
                    HStack(spacing: 6) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .foregroundColor(Theme.Colors.neonGreen)
                            .font(.caption2)

                        Text("Active collaboration")
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.neonGreen)

                        Spacer()

                        Text(space.lastActivity, style: .relative)
                            .font(.caption2)
                            .foregroundColor(Theme.Colors.textTertiary)
                    }
                }
            }
            .padding()
            .liquidGlassCard()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(space.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeaturedSpaceCard: View {
    let space: CollaborationSpace
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                // Featured indicator
                VStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.Colors.neonYellow)
                        .font(.title3)
                        .neonGlow(color: Theme.Colors.neonYellow, pulse: true)

                    Spacer()
                }

                // Space info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(space.color.opacity(0.3))
                                .frame(width: 40, height: 40)

                            Image(systemName: space.icon)
                                .foregroundColor(space.color)
                                .font(.title3)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(space.name)
                                .font(Theme.Typography.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Text("Featured • \(space.activeMembers) members")
                                .font(.caption2)
                                .foregroundColor(Theme.Colors.neonYellow)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.Colors.textTertiary)
                            .font(.caption)
                    }

                    Text(space.description ?? "High-impact collaboration space")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Theme.Colors.neonYellow.opacity(0.1),
                        space.color.opacity(0.1),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Theme.Colors.neonYellow.opacity(0.5), space.color.opacity(0.5),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Types

enum SpaceCategory: String, CaseIterable {
    case all = "All"
    case innovation = "Innovation"
    case engineering = "Engineering"
    case design = "Design"
    case marketing = "Marketing"
    case product = "Product"
    case crossFunctional = "Cross-Functional"

    var title: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "rectangle.grid.2x2"
        case .innovation: return "lightbulb.2.fill"
        case .engineering: return "gearshape.2.fill"
        case .design: return "paintbrush.fill"
        case .marketing: return "megaphone.fill"
        case .product: return "app.fill"
        case .crossFunctional: return "arrow.triangle.merge"
        }
    }

    var color: Color {
        switch self {
        case .all: return Theme.Colors.neonBlue
        case .innovation: return Theme.Colors.neonYellow
        case .engineering: return Theme.Colors.neonGreen
        case .design: return Theme.Colors.neonPink
        case .marketing: return Theme.Colors.neonOrange
        case .product: return Theme.Colors.neonBlue
        case .crossFunctional: return Theme.Colors.neonPurple ?? Theme.Colors.neonPink
        }
    }
}

struct AISpaceRecommendation: Identifiable {
    let id = UUID()
    let type: RecommendationType
    let title: String
    let description: String
    let confidence: Double
    let targetSpaceId: String?
}

enum RecommendationType {
    case join, create, skillMatch

    var icon: String {
        switch self {
        case .join: return "plus.circle"
        case .create: return "plus.square"
        case .skillMatch: return "arrow.2.squarepath"
        }
    }

    var color: Color {
        switch self {
        case .join: return Theme.Colors.neonGreen
        case .create: return Theme.Colors.neonBlue
        case .skillMatch: return Theme.Colors.neonOrange
        }
    }

    var actionText: String {
        switch self {
        case .join: return "Join Space"
        case .create: return "Create Space"
        case .skillMatch: return "Find Matches"
        }
    }
}

// MARK: - Extended CollaborationSpace Model

extension CollaborationSpace {
    var description: String? {
        switch name {
        case "Innovation Hub":
            return "Breakthrough ideas and creative problem-solving"
        case "Cross-Functional Bridge":
            return "Breaking down silos between departments"
        default:
            return nil
        }
    }

    var hasRecentActivity: Bool {
        return Date().timeIntervalSince(lastActivity) < 3600  // Active within last hour
    }

    var isUserMember: Bool {
        // In a real implementation, this would check user membership
        return Bool.random()
    }

    var lastActivity: Date {
        return Date().addingTimeInterval(-Double.random(in: 300...7200))  // Random recent activity
    }
}

// MARK: - View Model

class CollaborationSpacesViewModel: ObservableObject {
    @Published var allSpaces: [CollaborationSpace] = []
    @Published var filteredSpaces: [CollaborationSpace] = []
    @Published var featuredSpaces: [CollaborationSpace] = []
    @Published var aiRecommendations: [AISpaceRecommendation] = []

    @Published var totalSpaces = 0
    @Published var totalMembers = 0
    @Published var hasLiveActivity = false
    @Published var liveActivityCount = 0

    func loadSpaces() {
        // Load mock data
        allSpaces = [
            CollaborationSpace(
                name: "Innovation Hub",
                activeMembers: 12,
                skillsBeingShared: [
                    "AI/ML", "Product Design", "Strategy", "Data Science", "UX Research",
                ],
                icon: "lightbulb.2.fill",
                color: Theme.Colors.neonYellow
            ),
            CollaborationSpace(
                name: "Cross-Functional Bridge",
                activeMembers: 8,
                skillsBeingShared: ["Data Science", "Marketing", "Engineering", "Design"],
                icon: "arrow.triangle.merge",
                color: Theme.Colors.neonBlue
            ),
            CollaborationSpace(
                name: "Mobile Excellence",
                activeMembers: 15,
                skillsBeingShared: ["iOS Development", "Android", "React Native", "Flutter"],
                icon: "iphone",
                color: Theme.Colors.neonGreen
            ),
            CollaborationSpace(
                name: "Design System",
                activeMembers: 6,
                skillsBeingShared: ["UI/UX", "Design Systems", "Prototyping", "User Research"],
                icon: "paintbrush.fill",
                color: Theme.Colors.neonPink
            ),
        ]

        filteredSpaces = allSpaces
        featuredSpaces = Array(allSpaces.prefix(2))

        totalSpaces = allSpaces.count
        totalMembers = allSpaces.reduce(0) { $0 + $1.activeMembers }
        hasLiveActivity = true
        liveActivityCount = 3

        loadAIRecommendations()
    }

    func filterSpaces(by searchText: String, category: SpaceCategory) {
        var filtered = allSpaces

        // Filter by category
        if category != .all {
            filtered = filtered.filter { space in
                // Simple category matching logic
                switch category {
                case .innovation:
                    return space.name.contains("Innovation")
                        || space.skillsBeingShared.contains("AI/ML")
                case .engineering:
                    return space.skillsBeingShared.contains {
                        $0.contains("Development") || $0.contains("Engineering")
                    }
                case .design:
                    return space.skillsBeingShared.contains {
                        $0.contains("Design") || $0.contains("UX")
                    }
                case .crossFunctional:
                    return space.name.contains("Bridge") || space.name.contains("Cross")
                default:
                    return true
                }
            }
        }

        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { space in
                space.name.localizedCaseInsensitiveContains(searchText)
                    || space.skillsBeingShared.contains {
                        $0.localizedCaseInsensitiveContains(searchText)
                    }
            }
        }

        filteredSpaces = filtered
    }

    func getCategoryCount(_ category: SpaceCategory) -> Int {
        if category == .all {
            return allSpaces.count
        }

        return allSpaces.filter { space in
            switch category {
            case .innovation:
                return space.name.contains("Innovation")
                    || space.skillsBeingShared.contains("AI/ML")
            case .engineering:
                return space.skillsBeingShared.contains {
                    $0.contains("Development") || $0.contains("Engineering")
                }
            case .design:
                return space.skillsBeingShared.contains {
                    $0.contains("Design") || $0.contains("UX")
                }
            case .crossFunctional:
                return space.name.contains("Bridge") || space.name.contains("Cross")
            default:
                return true
            }
        }.count
    }

    func refreshRecommendations() {
        loadAIRecommendations()
        HapticManager.shared.impact(.light)
    }

    func joinSpace(_ spaceId: String) {
        // Implementation for joining space
        HapticManager.shared.impact(.medium)
    }

    private func loadAIRecommendations() {
        aiRecommendations = [
            AISpaceRecommendation(
                type: .join,
                title: "Join Innovation Hub",
                description:
                    "Your AI/ML skills would be valuable here. 3 members are looking for your expertise.",
                confidence: 0.92,
                targetSpaceId: "innovation-hub"
            ),
            AISpaceRecommendation(
                type: .skillMatch,
                title: "iOS Development Match",
                description:
                    "Found 2 iOS developers in Mobile Excellence who match your skill level.",
                confidence: 0.87,
                targetSpaceId: nil
            ),
            AISpaceRecommendation(
                type: .create,
                title: "Create Marketing Space",
                description:
                    "No active marketing collaboration spaces found. Create one to connect with marketing professionals.",
                confidence: 0.75,
                targetSpaceId: nil
            ),
        ]
    }
}

// MARK: - Create Space View (Placeholder)

struct CreateCollaborationSpaceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Collaboration Space")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.textPrimary)

                // Create space form implementation
            }
            .navigationTitle("New Space")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    CollaborationSpacesListView()
}
