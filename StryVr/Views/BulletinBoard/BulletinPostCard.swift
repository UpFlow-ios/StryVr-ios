import SwiftUI

struct BulletinPostCard: View {
    let post: BulletinPost
    var isPinned: Bool = false
    
    @State private var isLiked = false
    @State private var showingComments = false
    @State private var showingFullContent = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            postHeader
            
            // Content
            postContent
            
            // Actions
            postActions
        }
        .quantumGlassCard()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: isPinned ? 2 : 1)
        )
        .onAppear {
            markAsViewed()
        }
    }
    
    // MARK: - Header
    private var postHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Post Type Icon
                ZStack {
                    Circle()
                        .fill(Color(post.type.color).opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: post.type.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(post.type.color))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(post.type.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(post.type.color))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(post.type.color).opacity(0.1))
                            .cornerRadius(4)
                        
                        if post.isPriority {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        if isPinned {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    
                    Text("\(post.authorName) • \(post.authorRole)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(post.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if let expiresAt = post.expiresAt {
                        Text("Expires \(expiresAt, style: .relative)")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Title
            Text(post.title)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
                .padding(.top, 12)
        }
    }
    
    // MARK: - Content
    private var postContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Content Text
            let contentLines = post.content.components(separatedBy: .newlines)
            let shouldTruncate = contentLines.count > 4 && !showingFullContent
            let displayContent = shouldTruncate ? 
                contentLines.prefix(4).joined(separator: "\n") + "..." : 
                post.content
            
            Text(displayContent)
                .font(.body)
                .lineLimit(showingFullContent ? nil : 4)
                .padding(.horizontal, 16)
            
            // Show More/Less button
            if contentLines.count > 4 {
                Button(action: { showingFullContent.toggle() }) {
                    Text(showingFullContent ? "Show Less" : "Show More")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
            }
            
            // Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(post.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Attachments
            if !post.attachments.isEmpty {
                attachmentsList
            }
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - Actions
    private var postActions: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 16)
            
            HStack(spacing: 24) {
                // Like Button
                Button(action: toggleLike) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                        Text("\(post.likes)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Comment Button
                Button(action: { showingComments = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                            .foregroundColor(.secondary)
                        Text("\(post.comments)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Share Button
                Button(action: sharePost) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Views Count
                HStack(spacing: 4) {
                    Image(systemName: "eye")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text("\(post.views)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .sheet(isPresented: $showingComments) {
            BulletinCommentsView(post: post)
        }
    }
    
    // MARK: - Attachments
    private var attachmentsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Attachments")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(post.attachments) { attachment in
                        AttachmentCard(attachment: attachment)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var borderColor: Color {
        if isPinned {
            return .orange
        } else if post.isPriority {
            return .red.opacity(0.5)
        } else {
            return .gray.opacity(0.2)
        }
    }
    
    private var shadowColor: Color {
        if isPinned {
            return .orange.opacity(0.3)
        } else if post.isPriority {
            return .red.opacity(0.2)
        } else {
            return .black.opacity(0.1)
        }
    }
    
    // MARK: - Actions
    private func toggleLike() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isLiked.toggle()
        }
        
        // TODO: Call bulletin service to toggle like
        Task {
            // await bulletinService.toggleLike(for: post.id, companyId: post.companyId)
        }
    }
    
    private func sharePost() {
        // TODO: Implement sharing functionality
        print("Share post: \(post.title)")
    }
    
    private func markAsViewed() {
        // TODO: Call bulletin service to mark as viewed
        Task {
            // await bulletinService.markAsViewed(post.id, companyId: post.companyId)
        }
    }
}

// MARK: - Attachment Card
struct AttachmentCard: View {
    let attachment: BulletinAttachment
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: fileIcon)
                .font(.title3)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(attachment.fileName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(fileSizeString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .frame(width: 150)
    }
    
    private var fileIcon: String {
        switch attachment.fileType.lowercased() {
        case "pdf": return "doc.fill"
        case "jpg", "jpeg", "png", "gif": return "photo.fill"
        case "mp4", "mov", "avi": return "video.fill"
        case "doc", "docx": return "doc.text.fill"
        case "xls", "xlsx": return "tablecells.fill"
        case "ppt", "pptx": return "rectangle.stack.fill"
        default: return "doc.fill"
        }
    }
    
    private var fileSizeString: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(attachment.fileSize))
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(BulletinPost.samplePosts) { post in
                BulletinPostCard(post: post, isPinned: post.isSticky)
            }
        }
        .padding()
    }
    .background(ThemeManager.backgroundColor)
}
