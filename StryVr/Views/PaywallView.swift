//
//  PaywallView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI
import StoreKit
import os.log

/// Displays the paywall for premium subscription options
struct PaywallView: View {
    @State private var selectedPlan: SubscriptionPlan = .premium
    @State private var isProcessingPayment = false
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PaywallView")

    var body: some View {
        VStack {
            Text("🔓 Unlock Your Full Potential!")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)

            Text("Upgrade to premium and access exclusive learning features.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 15) {
                SubscriptionOption(plan: .freemium, selectedPlan: $selectedPlan)
                SubscriptionOption(plan: .plus, selectedPlan: $selectedPlan)
                SubscriptionOption(plan: .premium, selectedPlan: $selectedPlan)
                SubscriptionOption(plan: .enterprise, selectedPlan: $selectedPlan)
            }

            Spacer()

            Button(action: {
                purchaseSubscription()
            }) {
                Text(isProcessingPayment ? "Processing..." : "Upgrade to \(selectedPlan.rawValue)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .disabled(isProcessingPayment)
            .padding()

            Button("Restore Purchase") {
                restorePurchases()
            }
            .foregroundColor(.gray)
            .padding(.bottom)
        }
        .padding()
    }

    /// Handles the purchase process
    private func purchaseSubscription() {
        isProcessingPayment = true
        PaymentService.shared.purchaseProduct(selectedPlan.storeKitProduct) { success, error in
            isProcessingPayment = false
            if let error = error {
                logger.error("Purchase Error: \(error.localizedDescription)")
            } else if success {
                logger.info("Purchase successful for plan: \(selectedPlan.rawValue)")
            }
        }
    }

    /// Restores previous in-app purchases
    private func restorePurchases() {
        PaymentService.shared.restorePurchases { success, error in
            if let error = error {
                logger.error("Restore Purchase Error: \(error.localizedDescription)")
            } else if success {
                logger.info("Purchases restored successfully")
            }
        }
    }
}

/// Subscription plan options
enum SubscriptionPlan: String {
    case freemium = "Freemium"
    case plus = "Plus"
    case premium = "Premium"
    case enterprise = "Enterprise"

    var description: String {
        switch self {
        case .freemium:
            return "Basic access to learning paths and community features."
        case .plus:
            return "More in-depth mentorship sessions and advanced insights."
        case .premium:
            return "Full access to AI coaching, reports, and skill verification."
        case .enterprise:
            return "Custom solutions for businesses and organizations."
        }
    }

    var price: String {
        switch self {
        case .freemium:
            return "Free"
        case .plus:
            return "$9.99/month"
        case .premium:
            return "$19.99/month"
        case .enterprise:
            return "Contact Us"
        }
    }

    var storeKitProduct: SKProduct {
        // Placeholder for StoreKit product mapping (this needs to be configured in App Store Connect)
        return SKProduct()
    }
}

/// Subscription option row
struct SubscriptionOption: View {
    let plan: SubscriptionPlan
    @Binding var selectedPlan: SubscriptionPlan

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(plan.rawValue)
                    .font(.headline)
                Text(plan.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(plan.price)
                .font(.headline)
                .foregroundColor(selectedPlan == plan ? .blue : .gray)
        }
        .padding()
        .background(selectedPlan == plan ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(10)
        .onTapGesture {
            selectedPlan = plan
        }
    }
}
