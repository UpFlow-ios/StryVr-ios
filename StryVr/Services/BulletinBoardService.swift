import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

// MARK: - Bulletin Board Service

@MainActor
class BulletinBoardService: ObservableObject {
    
    // MARK: - Published Properties
    @Published var posts: [BulletinPost] = []
    @Published var events: [BulletinEvent] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // MARK: - Private Properties
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private var postsListener: ListenerRegistration?
    private var eventsListener: ListenerRegistration?
    
    // MARK: - Initialization
    init() {
        loadSampleData()
    }
    
    deinit {
        postsListener?.remove()
        eventsListener?.remove()
    }
    
    // MARK: - Public Methods
    
    /// Load bulletin board posts for the user's company
    func loadPosts(for companyId: String) {
        isLoading = true
        error = nil
        
        postsListener = db.collection("companies")
            .document(companyId)
            .collection("bulletinPosts")
            .order(by: "isSticky", descending: true)
            .order(by: "isPriority", descending: true)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error = "Failed to load posts: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.posts = []
                    self.isLoading = false
                    return
                }
                
                self.posts = documents.compactMap { document in
                    try? document.data(as: BulletinPost.self)
                }.filter { post in
                    // Filter out expired posts
                    if let expiresAt = post.expiresAt {
                        return expiresAt > Date()
                    }
                    return true
                }
                
                self.isLoading = false
            }
    }
    
    /// Load events for the user's company
    func loadEvents(for companyId: String) {
        eventsListener = db.collection("companies")
            .document(companyId)
            .collection("bulletinEvents")
            .order(by: "startDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error = "Failed to load events: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.events = []
                    return
                }
                
                self.events = documents.compactMap { document in
                    try? document.data(as: BulletinEvent.self)
                }.filter { event in
                    // Only show future events or events happening today
                    let calendar = Calendar.current
                    return calendar.isDateInToday(event.startDate) || event.startDate > Date()
                }
            }
    }
    
    /// Create a new bulletin post
    func createPost(_ post: BulletinPost) async throws {
        try await db.collection("companies")
            .document(post.companyId)
            .collection("bulletinPosts")
            .document(post.id)
            .setData(from: post)
    }
    
    /// Update an existing post
    func updatePost(_ post: BulletinPost) async throws {
        try await db.collection("companies")
            .document(post.companyId)
            .collection("bulletinPosts")
            .document(post.id)
            .setData(from: post)
    }
    
    /// Delete a post
    func deletePost(_ post: BulletinPost) async throws {
        try await db.collection("companies")
            .document(post.companyId)
            .collection("bulletinPosts")
            .document(post.id)
            .delete()
    }
    
    /// Like/unlike a post
    func toggleLike(for postId: String, companyId: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let postRef = db.collection("companies")
            .document(companyId)
            .collection("bulletinPosts")
            .document(postId)
        
        let likeRef = postRef.collection("likes").document(userId)
        
        try await db.runTransaction { transaction, errorPointer in
            let likeDoc: DocumentSnapshot
            do {
                try likeDoc = transaction.getDocument(likeRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            if likeDoc.exists {
                // Unlike
                transaction.deleteDocument(likeRef)
                transaction.updateData(["likes": FieldValue.increment(Int64(-1))], forDocument: postRef)
            } else {
                // Like
                transaction.setData(["userId": userId, "likedAt": Timestamp()], forDocument: likeRef)
                transaction.updateData(["likes": FieldValue.increment(Int64(1))], forDocument: postRef)
            }
            return nil
        }
    }
    
    /// Add a comment to a post
    func addComment(_ comment: BulletinComment, to companyId: String) async throws {
        try await db.collection("companies")
            .document(companyId)
            .collection("bulletinPosts")
            .document(comment.postId)
            .collection("comments")
            .document(comment.id)
            .setData(from: comment)
        
        // Increment comment count
        try await db.collection("companies")
            .document(companyId)
            .collection("bulletinPosts")
            .document(comment.postId)
            .updateData(["comments": FieldValue.increment(Int64(1))])
    }
    
    /// Create a new event
    func createEvent(_ event: BulletinEvent) async throws {
        try await db.collection("companies")
            .document(event.companyId)
            .collection("bulletinEvents")
            .document(event.id)
            .setData(from: event)
    }
    
    /// RSVP to an event
    func rsvpToEvent(_ eventId: String, companyId: String, attending: Bool) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let eventRef = db.collection("companies")
            .document(companyId)
            .collection("bulletinEvents")
            .document(eventId)
        
        let rsvpRef = eventRef.collection("rsvps").document(userId)
        
        try await db.runTransaction { transaction, errorPointer in
            let rsvpDoc: DocumentSnapshot
            do {
                try rsvpDoc = transaction.getDocument(rsvpRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            if attending {
                if !rsvpDoc.exists {
                    transaction.setData([
                        "userId": userId,
                        "attending": true,
                        "rsvpAt": Timestamp()
                    ], forDocument: rsvpRef)
                    transaction.updateData(["currentAttendees": FieldValue.increment(Int64(1))], forDocument: eventRef)
                }
            } else {
                if rsvpDoc.exists {
                    transaction.deleteDocument(rsvpRef)
                    transaction.updateData(["currentAttendees": FieldValue.increment(Int64(-1))], forDocument: eventRef)
                }
            }
            return nil
        }
    }
    
    /// Mark a post as viewed
    func markAsViewed(_ postId: String, companyId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let viewRef = db.collection("companies")
            .document(companyId)
            .collection("bulletinPosts")
            .document(postId)
            .collection("views")
            .document(userId)
        
        do {
            let viewDoc = try await viewRef.getDocument()
            if !viewDoc.exists {
                try await viewRef.setData([
                    "userId": userId,
                    "viewedAt": Timestamp()
                ])
                
                // Increment view count
                try await db.collection("companies")
                    .document(companyId)
                    .collection("bulletinPosts")
                    .document(postId)
                    .updateData(["views": FieldValue.increment(Int64(1))])
            }
        } catch {
            print("Error marking post as viewed: \(error)")
        }
    }
    
    /// Get posts filtered by type
    func getPostsByType(_ type: BulletinPostType) -> [BulletinPost] {
        return posts.filter { $0.type == type }
    }
    
    /// Get upcoming events (next 7 days)
    func getUpcomingEvents() -> [BulletinEvent] {
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return events.filter { $0.startDate <= nextWeek }
    }
    
    /// Clear error
    func clearError() {
        error = nil
    }
    
    // MARK: - Sample Data (Development)
    private func loadSampleData() {
        // Load sample data for development/preview
        posts = BulletinPost.samplePosts
        
        // Sample events
        events = [
            BulletinEvent(
                title: "All-Hands Meeting",
                description: "Monthly company update with Q4 results and Q1 planning",
                startDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date().addingTimeInterval(3600)) ?? Date(),
                location: "Main Conference Room",
                isVirtual: true,
                meetingLink: "https://zoom.us/j/123456789",
                organizer: "David Kim",
                maxAttendees: 200,
                currentAttendees: 45,
                isRSVPRequired: true,
                tags: ["all-hands", "quarterly"],
                companyId: "company_001"
            ),
            
            BulletinEvent(
                title: "Holiday Party",
                description: "Annual company holiday celebration with dinner and entertainment",
                startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date().addingTimeInterval(14400)) ?? Date(),
                location: "Grand Ballroom, Downtown Hotel",
                organizer: "Lisa Thompson",
                maxAttendees: 150,
                currentAttendees: 89,
                isRSVPRequired: true,
                tags: ["holiday", "social"],
                companyId: "company_001"
            )
        ]
    }
}
