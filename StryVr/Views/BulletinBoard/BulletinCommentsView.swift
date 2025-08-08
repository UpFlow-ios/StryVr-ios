import SwiftUI

struct BulletinCommentsView: View {
    let post: BulletinPost
    @Environment(\.dismiss) private var dismiss
    @State private var newComment = ""
    @State private var comments: [BulletinComment] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Comments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(comments) { comment in
                            CommentCard(comment: comment)
                        }
                    }
                    .padding()
                }
                
                // Comment Input
                commentInputBar
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadComments()
        }
    }
    
    // MARK: - Comment Input
    private var commentInputBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // User Avatar
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
                
                // Text Field
                TextField("Add a comment...", text: $newComment, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                
                // Send Button
                Button(action: addComment) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(newComment.isEmpty ? .gray : .blue)
                }
                .disabled(newComment.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(.regularMaterial)
    }
    
    // MARK: - Methods
    private func loadComments() {
        // Sample comments for development
        comments = [
            BulletinComment(
                postId: post.id,
                authorId: "user_001",
                authorName: "John Smith",
                authorRole: "Senior Developer",
                content: "Congratulations Sarah! Well deserved recognition for all your hard work on the cloud migration.",
                createdAt: Date().addingTimeInterval(-3600),
                likes: 5
            ),
            BulletinComment(
                postId: post.id,
                authorId: "user_002",
                authorName: "Maria Garcia",
                authorRole: "Product Manager",
                content: "Sarah has been an incredible mentor to our team. This recognition is absolutely well deserved! 🎉",
                createdAt: Date().addingTimeInterval(-1800),
                likes: 8
            ),
            BulletinComment(
                postId: post.id,
                authorId: "user_003",
                authorName: "David Chen",
                authorRole: "DevOps Engineer",
                content: "Working with Sarah on the migration was amazing. She taught me so much about cloud architecture!",
                createdAt: Date().addingTimeInterval(-900),
                likes: 3
            )
        ]
    }
    
    private func addComment() {
        guard !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let comment = BulletinComment(
            postId: post.id,
            authorId: "current_user",
            authorName: "You",
            authorRole: "Developer",
            content: newComment,
            likes: 0
        )
        
        comments.append(comment)
        newComment = ""
        
        // TODO: Call service to add comment
        Task {
            // await bulletinService.addComment(comment, to: post.companyId)
        }
    }
}

// MARK: - Comment Card
struct CommentCard: View {
    let comment: BulletinComment
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Author and time
            HStack {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.authorName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(comment.authorRole)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(comment.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Comment content
            Text(comment.content)
                .font(.body)
                .padding(.leading, 44) // Align with author name
            
            // Actions
            HStack {
                Button(action: toggleLike) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                            .font(.caption)
                        
                        if comment.likes > 0 {
                            Text("\(comment.likes)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Button("Reply") {
                    // TODO: Implement reply functionality
                }
                .font(.caption)
                .foregroundColor(.blue)
                
                Spacer()
            }
            .padding(.leading, 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private func toggleLike() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isLiked.toggle()
        }
        
        // TODO: Call service to toggle like
    }
}

// MARK: - Preview
#Preview {
    BulletinCommentsView(post: BulletinPost.samplePosts[0])
}
