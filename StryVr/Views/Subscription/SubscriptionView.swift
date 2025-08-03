import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var subscriptionService = SubscriptionService()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTier: SubscriptionTier = .premium
    @State private var isYearly = true
    @State private var showingPurchase = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    headerSection
                    
                    // Pricing Toggle
                    pricingToggleSection
                    
                    // Subscription Tiers
                    subscriptionTiersSection
                    
                    // Features Comparison
                    featuresComparisonSection
                    
                    // Additional Revenue Streams
                    revenueStreamsSection
                    
                    // CTA Button
                    ctaSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.05, green: 0.05, blue: 0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Choose Your Plan")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingPurchase) {
            PurchaseView(
                tier: selectedTier,
                isYearly: isYearly,
                subscriptionService: subscriptionService
            )
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Unlock Your Full Potential")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Choose the plan that accelerates your career growth with AI-powered insights and personalized development paths.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Pricing Toggle
    private var pricingToggleSection: some View {
        VStack(spacing: 12) {
            Text("Billing Cycle")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                Button("Monthly") {
                    isYearly = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isYearly ? Color.clear : Color.blue.opacity(0.3))
                .foregroundColor(isYearly ? .gray : .white)
                .cornerRadius(8, corners: [.topLeading, .bottomLeading])
                
                Button("Yearly") {
                    isYearly = true
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isYearly ? Color.blue.opacity(0.3) : Color.clear)
                .foregroundColor(isYearly ? .white : .gray)
                .cornerRadius(8, corners: [.topTrailing, .bottomTrailing])
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            if isYearly {
                Text("Save up to 17% with yearly billing")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Subscription Tiers
    private var subscriptionTiersSection: some View {
        VStack(spacing: 20) {
            ForEach(SubscriptionTier.allCases.filter { $0 != .free }, id: \.self) { tier in
                SubscriptionTierCard(
                    tier: tier,
                    isYearly: isYearly,
                    isSelected: selectedTier == tier
                ) {
                    selectedTier = tier
                }
            }
        }
    }
    
    // MARK: - Features Comparison
    private var featuresComparisonSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What's Included")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVStack(spacing: 12) {
                ForEach(SubscriptionFeature.allCases, id: \.self) { feature in
                    FeatureRow(
                        feature: feature,
                        tiers: SubscriptionTier.allCases.filter { $0 != .free }
                    )
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    // MARK: - Revenue Streams
    private var revenueStreamsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Additional Services")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(RevenueStream.allCases, id: \.self) { stream in
                    RevenueStreamCard(stream: stream)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingPurchase = true
            }) {
                HStack {
                    Text("Start \(selectedTier.displayName) Plan")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(priceText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(subscriptionService.isLoading)
            
            if subscriptionService.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
            if let errorMessage = subscriptionService.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal)
    }
    
    private var priceText: String {
        let price = isYearly ? selectedTier.yearlyPrice : selectedTier.monthlyPrice
        let period = isYearly ? "year" : "month"
        return "$\(price)/\(period)"
    }
}

// MARK: - Subscription Tier Card
struct SubscriptionTierCard: View {
    let tier: SubscriptionTier
    let isYearly: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tier.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(tierDescription)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(priceText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(periodText)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Popular badge for Premium
                if tier == .premium {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Most Popular")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(8)
                }
                
                // Top features preview
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                    ForEach(Array(tier.features.prefix(3)), id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            
                            Text(feature.displayName)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var priceText: String {
        let price = isYearly ? tier.yearlyPrice : tier.monthlyPrice
        return "$\(price)"
    }
    
    private var periodText: String {
        return isYearly ? "per year" : "per month"
    }
    
    private var tierDescription: String {
        switch tier {
        case .premium: return "Perfect for individual professionals"
        case .team: return "Ideal for growing teams"
        case .enterprise: return "For large organizations"
        default: return ""
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let feature: SubscriptionFeature
    let tiers: [SubscriptionTier]
    
    var body: some View {
        HStack {
            Text(feature.displayName)
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(tiers, id: \.self) { tier in
                if tier.features.contains(feature) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red.opacity(0.5))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Revenue Stream Card
struct RevenueStreamCard: View {
    let stream: RevenueStream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stream.displayName)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(stream.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Text(stream.estimatedRevenue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Purchase View
struct PurchaseView: View {
    let tier: SubscriptionTier
    let isYearly: Bool
    let subscriptionService: SubscriptionService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Purchase Summary
                VStack(spacing: 16) {
                    Image(systemName: "creditcard.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Complete Your Purchase")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 8) {
                        Text("\(tier.displayName) Plan")
                            .font(.headline)
                        
                        Text(priceText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        if isYearly {
                            Text("Save 17% with yearly billing")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                // Features included
                VStack(alignment: .leading, spacing: 12) {
                    Text("You'll get:")
                        .font(.headline)
                    
                    ForEach(tier.features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature.displayName)
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                Spacer()
                
                // Purchase Button
                Button("Complete Purchase") {
                    // Handle purchase
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(subscriptionService.isLoading)
            }
            .padding()
            .navigationTitle("Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var priceText: String {
        let price = isYearly ? tier.yearlyPrice : tier.monthlyPrice
        let period = isYearly ? "year" : "month"
        return "$\(price)/\(period)"
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SubscriptionView()
} 