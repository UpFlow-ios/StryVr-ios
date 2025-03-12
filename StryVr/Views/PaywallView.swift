//
//  PaywallView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import SwiftUI
import StoreKit
import os.log

/// Displays the paywall with AI-based trial recommendations and premium offers
struct PaywallView: View {
    @State private var selectedPlan: SubscriptionPlan = .premium
    @State private var isProcessingPayment = false
    @State private var limitedTimeOffer: String?
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

            if let offer = limitedTimeOffer {
                Text("🔥 Special Offer: \(offer)")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

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
        .onAppear {
            generateAIRecommendation()
            checkLimitedTimeOffers()
        }
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

    /// Generates AI-based subscription recommendations
    private func generateAIRecommendation() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let recommendedPlan: SubscriptionPlan = .premium  // AI logic would determine this based on user activity
            DispatchQueue.main.async {
                self.selectedPlan = recommendedPlan
                logger.info("AI Recommended Plan: \(recommendedPlan.rawValue)")
            }
        }
    }

    /// Checks for limited-time premium offers
    private func checkLimitedTimeOffers() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let offer = "Upgrade now & get 20% off for the first 3 months!"
            DispatchQueue.main.async {
                self.limitedTimeOffer = offer
                logger.info("Limited-Time Offer Activated: \(offer)")
            }
        }
    }
}

