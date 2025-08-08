import SwiftUI
import PhotosUI

struct CreateBulletinPostView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var bulletinService = BulletinBoardService()
    
    // Form data
    @State private var title = ""
    @State private var content = ""
    @State private var selectedType: BulletinPostType = .announcement
    @State private var selectedVisibility: BulletinVisibility = .allEmployees
    @State private var isSticky = false
    @State private var isPriority = false
    @State private var tags: [String] = []
    @State private var newTag = ""
    @State private var expirationDate: Date?
    @State private var hasExpiration = false
    
    // UI state
    @State private var isPosting = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Post Type Selection
                    postTypeSection
                    
                    // Basic Information
                    basicInfoSection
                    
                    // Content
                    contentSection
                    
                    // Tags
                    tagsSection
                    
                    // Settings
                    settingsSection
                    
                    // Visibility
                    visibilitySection
                    
                    // Expiration
                    expirationSection
                }
                .padding()
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .disabled(title.isEmpty || content.isEmpty || isPosting)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Post Type Section
    private var postTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Post Type")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(BulletinPostType.allCases, id: \.self) { type in
                    PostTypeCard(
                        type: type,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                }
            }
        }
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter post title...", text: $title)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Content")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("Write your post content...", text: $content, axis: .vertical)
                .textFieldStyle(.plain)
                .padding()
                .frame(minHeight: 120)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }
    
    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tags")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Existing tags
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Button(action: { removeTag(tag) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            
            // Add new tag
            HStack {
                TextField("Add tag...", text: $newTag)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        addTag()
                    }
                
                Button("Add", action: addTag)
                    .disabled(newTag.isEmpty)
            }
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                Toggle("Pin to top", isOn: $isSticky)
                Toggle("High priority", isOn: $isPriority)
            }
        }
    }
    
    // MARK: - Visibility Section
    private var visibilitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Visibility")
                .font(.headline)
                .fontWeight(.semibold)
            
            Picker("Visibility", selection: $selectedVisibility) {
                ForEach([BulletinVisibility.allEmployees, .departmentOnly, .managementOnly], id: \.self) { visibility in
                    Text(visibility.displayName).tag(visibility)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Expiration Section
    private var expirationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expiration")
                .font(.headline)
                .fontWeight(.semibold)
            
            Toggle("Set expiration date", isOn: $hasExpiration)
            
            if hasExpiration {
                DatePicker(
                    "Expires on",
                    selection: Binding(
                        get: { expirationDate ?? Date().addingTimeInterval(86400 * 7) },
                        set: { expirationDate = $0 }
                    ),
                    in: Date()...,
                    displayedComponents: [.date]
                )
            }
        }
    }
    
    // MARK: - Methods
    private func addTag() {
        let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else { return }
        
        tags.append(trimmedTag)
        newTag = ""
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func createPost() {
        guard !title.isEmpty, !content.isEmpty else { return }
        
        isPosting = true
        
        let post = BulletinPost(
            title: title,
            content: content,
            type: selectedType,
            authorId: "current_user", // TODO: Get from auth service
            authorName: "Current User", // TODO: Get from user profile
            authorRole: "Manager", // TODO: Get from user profile
            expiresAt: hasExpiration ? expirationDate : nil,
            isSticky: isSticky,
            isPriority: isPriority,
            tags: tags,
            companyId: "company_001", // TODO: Get from user session
            visibility: selectedVisibility
        )
        
        Task {
            do {
                try await bulletinService.createPost(post)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isPosting = false
                }
            }
        }
    }
}

// MARK: - Post Type Card
struct PostTypeCard: View {
    let type: BulletinPostType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : Color(type.color))
                
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(type.color) : Color(type.color).opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(type.color), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    CreateBulletinPostView()
}
