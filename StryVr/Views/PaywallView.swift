//
//  PaywallView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//

import OSLog
import StoreKit
import SwiftUI

/// Displays the paywall with AI-based trial recommendations and premium offers
struct PaywallView: View {
    @State private var selectedPlan: SubscriptionPlan = .premium
    @State private var isProcessingPayment = false
    @State private var limitedTimeOffer: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "PaywallView")

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // MARK: - Header

                    VStack(spacing: Theme.Spacing.small) {
                        Text("🔓 Unlock Your Full Potential!")
                            .font(Font.Style.title)
                            .foregroundColor(.whiteText)
                            .multilineTextAlignment(.center)

                        Text("Upgrade to premium and access exclusive learning features.")
                            .font(Font.Style.body)
                            .foregroundColor(.lightGray)
                            .multilineTextAlignment(.center)

                        if let offer = limitedTimeOffer {
                            Text("🔥 Special Offer: \(offer)")
                                .font(Font.Style.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, Theme.Spacing.large)
                    .accessibilityElement(children: .combine)

                    // MARK: - Plan Selector

                    VStack(spacing: Theme.Spacing.medium) {
                        ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                            SubscriptionOption(plan: plan, selectedPlan: $selectedPlan)
                        }
                    }

                    // MARK: - Action Button

                    VStack(spacing: Theme.Spacing.medium) {
                        Button(action: purchaseSubscription) {
                            if isProcessingPayment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Upgrade to \(selectedPlan.rawValue.capitalized)")
                                    .font(Font.Style.buttonText)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.neonBlue)
                                    .cornerRadius(12)
                            }
                        }
                        .disabled(isProcessingPayment)
                        .accessibilityLabel("Upgrade to \(selectedPlan.rawValue)")

                        Button("Restore Purchase", action: restorePurchases)
                            .font(Font.Style.caption)
                            .foregroundColor(.lightGray)
                    }

                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.large)
            }
        }
        .onAppear {
            generateAIRecommendation()
            checkLimitedTimeOffers()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - Purchase Logic

    private func purchaseSubscription() {
        isProcessingPayment = true
        PaymentService.shared.purchaseProduct(selectedPlan.storeKitProduct) { success, error in
            DispatchQueue.main.async {
                isProcessingPayment = false
                if let error = error {
                    handleError("Purchase Error: \(error.localizedDescription)")
                } else if success {
                    logger.info("✅ Purchase successful for plan: \(selectedPlan.rawValue)")
                }
            }
        }
    }

    private func restorePurchases() {
        PaymentService.shared.restorePurchases { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    handleError("Restore Error: \(error.localizedDescription)")
                } else if success {
                    logger.info("✅ Purchases restored successfully")
                }
            }
        }
    }

    // MARK: - AI-Driven Trial Suggestion

    private func generateAIRecommendation() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                self.selectedPlan = recommended
                let recommended: SubscriptionPlan = .premium  // Replace with AI logic later
                logger.info("🧠 AI Recommended Plan: \(recommended.rawValue)")
            }
        }
    }

    private func checkLimitedTimeOffers() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let offer = "Upgrade now & get 20% off for 3 months!"
            DispatchQueue.main.async {
                self.limitedTimeOffer = offer
                logger.info("🔥 Limited-Time Offer Activated")
            }
        }
    }

    // MARK: - Error Handling

    private func handleError(_ message: String) {
        logger.error("❌ \(message)")
        alertMessage = message
        showAlert = true
    }
}
