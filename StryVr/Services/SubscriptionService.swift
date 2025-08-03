import Foundation
import StoreKit
import FirebaseFirestore
import OSLog

@MainActor
class SubscriptionService: ObservableObject {
    private let logger = Logger(subsystem: "com.stryvr.app", category: "SubscriptionService")
    
    @Published var currentSubscription: Subscription?
    @Published var availableProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // User behavior tracking for algorithm
    @Published var userBehavior: UserBehavior = UserBehavior()
    
    private let db = Firestore.firestore()
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        Task {
            await loadProducts()
            await loadCurrentSubscription()
            startUserBehaviorTracking()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Product Management
    func loadProducts() async {
        isLoading = true
        
        do {
            let productIdentifiers = Set([
                "com.stryvr.premium.monthly",
                "com.stryvr.premium.yearly",
                "com.stryvr.team.monthly",
                "com.stryvr.team.yearly",
                "com.stryvr.enterprise.monthly",
                "com.stryvr.enterprise.yearly"
            ])
            
            let products = try await Product.products(for: productIdentifiers)
            availableProducts = products.sorted { $0.price < $1.price }
            
            logger.info("Loaded \(products.count) products successfully")
        } catch {
            logger.error("Failed to load products: \(error.localizedDescription)")
            errorMessage = "Failed to load subscription options"
        }
        
        isLoading = false
    }
    
    // MARK: - Purchase Management
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionFromTransaction(transaction)
                await transaction.finish()
                
                logger.info("Purchase successful for product: \(product.id)")
                return true
                
            case .userCancelled:
                logger.info("Purchase cancelled by user")
                return false
                
            case .pending:
                logger.info("Purchase pending approval")
                return false
                
            @unknown default:
                logger.error("Unknown purchase result")
                return false
            }
        } catch {
            logger.error("Purchase failed: \(error.localizedDescription)")
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            return false
        }
        
        isLoading = false
    }
    
    // MARK: - Subscription Management
    func loadCurrentSubscription() async {
        guard let userId = AuthService.shared.currentUser?.uid else { return }
        
        do {
            let document = try await db.collection("subscriptions").document(userId).getDocument()
            
            if let data = document.data() {
                currentSubscription = try Firestore.Decoder().decode(Subscription.self, from: data)
                logger.info("Loaded subscription: \(currentSubscription?.tier.rawValue ?? "none")")
            }
        } catch {
            logger.error("Failed to load subscription: \(error.localizedDescription)")
        }
    }
    
    private func updateSubscriptionFromTransaction(_ transaction: Transaction) async {
        guard let userId = AuthService.shared.currentUser?.uid else { return }
        
        let subscription = Subscription(
            id: transaction.id.description,
            tier: tierFromProductId(transaction.productID),
            startDate: transaction.purchaseDate,
            endDate: transaction.expirationDate,
            isActive: true,
            isTrial: false,
            trialEndDate: nil,
            autoRenew: true,
            paymentMethod: .applePay
        )
        
        do {
            try await db.collection("subscriptions").document(userId).setData(from: subscription)
            currentSubscription = subscription
            
            // Track purchase behavior for algorithm
            await trackPurchaseBehavior(subscription.tier)
            
            logger.info("Updated subscription for user: \(userId)")
        } catch {
            logger.error("Failed to update subscription: \(error.localizedDescription)")
        }
    }
    
    private func tierFromProductId(_ productId: String) -> SubscriptionTier {
        if productId.contains("premium") {
            return .premium
        } else if productId.contains("team") {
            return .team
        } else if productId.contains("enterprise") {
            return .enterprise
        } else {
            return .free
        }
    }
    
    // MARK: - User Behavior Tracking for Algorithm
    func startUserBehaviorTracking() {
        updateListenerTask = Task {
            for await _ in Timer.publish(every: 300, on: .main, in: .common).autoconnect() {
                await saveUserBehavior()
            }
        }
    }
    
    func trackFeatureUsage(_ feature: SubscriptionFeature) {
        userBehavior.featureUsage[feature.rawValue, default: 0] += 1
        userBehavior.lastFeatureUsed = feature.rawValue
        userBehavior.lastActivityDate = Date()
    }
    
    func trackGoalProgress(_ goalType: String, progress: Double) {
        userBehavior.goalProgress[goalType] = progress
        userBehavior.goalsCompleted += 1
    }
    
    func trackSkillInteraction(_ skill: String, timeSpent: TimeInterval) {
        userBehavior.skillInteractions[skill, default: 0] += timeSpent
        userBehavior.totalTimeSpent += timeSpent
    }
    
    func trackCareerPathExploration(_ path: String) {
        userBehavior.careerPathsExplored.insert(path)
    }
    
    func trackFeedbackGiven(_ feedback: String, rating: Int) {
        userBehavior.feedbackHistory.append(FeedbackEntry(
            feedback: feedback,
            rating: rating,
            date: Date()
        ))
    }
    
    private func trackPurchaseBehavior(_ tier: SubscriptionTier) async {
        userBehavior.purchaseHistory.append(PurchaseEntry(
            tier: tier,
            date: Date()
        ))
        
        // Update user preferences based on purchase
        switch tier {
        case .premium:
            userBehavior.preferences.advancedAnalytics = true
            userBehavior.preferences.premiumContent = true
        case .team:
            userBehavior.preferences.teamFeatures = true
            userBehavior.preferences.collaboration = true
        case .enterprise:
            userBehavior.preferences.enterpriseFeatures = true
            userBehavior.preferences.customization = true
        case .free:
            break
        }
    }
    
    private func saveUserBehavior() async {
        guard let userId = AuthService.shared.currentUser?.uid else { return }
        
        do {
            try await db.collection("userBehavior").document(userId).setData(from: userBehavior)
            logger.info("Saved user behavior data")
        } catch {
            logger.error("Failed to save user behavior: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Algorithm Insights
    func getUserInsights() -> UserInsights {
        let mostUsedFeature = userBehavior.featureUsage.max(by: { $0.value < $1.value })?.key
        let topSkills = userBehavior.skillInteractions.sorted(by: { $0.value > $1.value }).prefix(3)
        let averageRating = userBehavior.feedbackHistory.map(\.rating).reduce(0, +) / max(userBehavior.feedbackHistory.count, 1)
        
        return UserInsights(
            mostUsedFeature: mostUsedFeature,
            topSkills: Array(topSkills.map { $0.key }),
            averageRating: averageRating,
            totalTimeSpent: userBehavior.totalTimeSpent,
            goalsCompleted: userBehavior.goalsCompleted,
            careerPathsExplored: Array(userBehavior.careerPathsExplored),
            preferences: userBehavior.preferences
        )
    }
    
    // MARK: - Helper Functions
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - User Behavior Models
struct UserBehavior: Codable {
    var featureUsage: [String: Int] = [:]
    var skillInteractions: [String: TimeInterval] = [:]
    var goalProgress: [String: Double] = [:]
    var careerPathsExplored: Set<String> = []
    var feedbackHistory: [FeedbackEntry] = []
    var purchaseHistory: [PurchaseEntry] = []
    var preferences: UserPreferences = UserPreferences()
    
    var lastFeatureUsed: String?
    var lastActivityDate: Date?
    var totalTimeSpent: TimeInterval = 0
    var goalsCompleted: Int = 0
}

struct UserPreferences: Codable {
    var advancedAnalytics: Bool = false
    var premiumContent: Bool = false
    var teamFeatures: Bool = false
    var collaboration: Bool = false
    var enterpriseFeatures: Bool = false
    var customization: Bool = false
    var aiInsights: Bool = true
    var gamification: Bool = true
}

struct FeedbackEntry: Codable {
    let feedback: String
    let rating: Int
    let date: Date
}

struct PurchaseEntry: Codable {
    let tier: SubscriptionTier
    let date: Date
}

struct UserInsights {
    let mostUsedFeature: String?
    let topSkills: [String]
    let averageRating: Int
    let totalTimeSpent: TimeInterval
    let goalsCompleted: Int
    let careerPathsExplored: [String]
    let preferences: UserPreferences
}

// MARK: - Errors
enum SubscriptionError: Error {
    case verificationFailed
    case productNotFound
    case purchaseFailed
    case subscriptionNotFound
} 