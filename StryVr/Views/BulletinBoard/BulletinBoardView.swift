import SwiftUI

struct BulletinBoardView: View {
    @StateObject private var bulletinService = BulletinBoardService()
    @State private var selectedTab: BulletinTab = .all
    @State private var showingCreatePost = false
    @State private var showingFilters = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Bar
                bulletinTabBar
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Search and Filter Bar
                        searchAndFilterBar
                        
                        // Featured/Pinned Posts
                        if !pinnedPosts.isEmpty {
                            pinnedPostsSection
                        }
                        
                        // Main Content
                        switch selectedTab {
                        case .all:
                            allPostsContent
                        case .announcements:
                            announcementsContent
                        case .events:
                            eventsContent
                        case .recognition:
                            recognitionContent
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100) // Tab bar padding
                }
                .refreshable {
                    await refreshContent()
                }
            }
            .background(ThemeManager.backgroundColor)
            .navigationTitle("Company Board")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreatePost = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            CreateBulletinPostView()
        }
        .task {
            await loadContent()
        }
    }
    
    // MARK: - Tab Bar
    private var bulletinTabBar: some View {
        HStack(spacing: 0) {
            ForEach(BulletinTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.title3)
                        Text(tab.title)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    // MARK: - Search and Filter
    private var searchAndFilterBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search posts...", text: $searchText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            
            Button(action: { showingFilters.toggle() }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Pinned Posts
    private var pinnedPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "pin.fill")
                    .foregroundColor(.orange)
                Text("Pinned Posts")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            ForEach(pinnedPosts) { post in
                BulletinPostCard(post: post, isPinned: true)
            }
        }
    }
    
    // MARK: - Content Sections
    private var allPostsContent: some View {
        VStack(spacing: 16) {
            ForEach(filteredPosts) { post in
                BulletinPostCard(post: post)
            }
        }
    }
    
    private var announcementsContent: some View {
        VStack(spacing: 16) {
            ForEach(announcementPosts) { post in
                BulletinPostCard(post: post)
            }
        }
    }
    
    private var eventsContent: some View {
        VStack(spacing: 16) {
            // Upcoming Events
            if !bulletinService.events.isEmpty {
                upcomingEventsSection
            }
            
            // Event Posts
            ForEach(eventPosts) { post in
                BulletinPostCard(post: post)
            }
        }
    }
    
    private var recognitionContent: some View {
        VStack(spacing: 16) {
            ForEach(recognitionPosts) { post in
                BulletinPostCard(post: post)
            }
        }
    }
    
    private var upcomingEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.green)
                Text("Upcoming Events")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            ForEach(bulletinService.getUpcomingEvents()) { event in
                BulletinEventCard(event: event)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var pinnedPosts: [BulletinPost] {
        bulletinService.posts.filter { $0.isSticky }
    }
    
    private var filteredPosts: [BulletinPost] {
        let posts = bulletinService.posts.filter { !$0.isSticky }
        if searchText.isEmpty {
            return posts
        }
        return posts.filter { post in
            post.title.localizedCaseInsensitiveContains(searchText) ||
            post.content.localizedCaseInsensitiveContains(searchText) ||
            post.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private var announcementPosts: [BulletinPost] {
        bulletinService.getPostsByType(.announcement)
    }
    
    private var eventPosts: [BulletinPost] {
        bulletinService.posts.filter { 
            $0.type == .event || $0.type == .socialEvent 
        }
    }
    
    private var recognitionPosts: [BulletinPost] {
        bulletinService.posts.filter { 
            $0.type == .employeeRecognition || $0.type == .achievement || $0.type == .milestone
        }
    }
    
    // MARK: - Methods
    @MainActor
    private func loadContent() async {
        // In real app, get company ID from user session
        let companyId = "company_001"
        bulletinService.loadPosts(for: companyId)
        bulletinService.loadEvents(for: companyId)
    }
    
    @MainActor
    private func refreshContent() async {
        await loadContent()
    }
}

// MARK: - Tab Enum
enum BulletinTab: CaseIterable {
    case all
    case announcements
    case events
    case recognition
    
    var title: String {
        switch self {
        case .all: return "All"
        case .announcements: return "News"
        case .events: return "Events"
        case .recognition: return "Recognition"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "doc.text.fill"
        case .announcements: return "megaphone.fill"
        case .events: return "calendar"
        case .recognition: return "star.fill"
        }
    }
}

// MARK: - Preview
#Preview {
    BulletinBoardView()
}
