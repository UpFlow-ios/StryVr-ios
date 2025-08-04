//
//  PaywallView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//  🌟 iOS 18 Liquid Glass Implementation
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
    @Namespace private var glassNamespace
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
                                .applySpecialOfferGlassEffect()
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
                                    .applyUpgradeButtonGlassEffect()
                            }
                        }
                        .disabled(isProcessingPayment)
                        .accessibilityLabel("Upgrade to \(selectedPlan.rawValue)")

                        Button("Restore Purchase", action: restorePurchases)
                            .font(Font.Style.caption)
                            .foregroundColor(.lightGray)
                            .applyRestoreButtonGlassEffect()
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

// MARK: - iOS 18 Liquid Glass Helper Extensions

extension View {
    /// Apply special offer glass effect with iOS 18 Liquid Glass
    func applySpecialOfferGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.red.opacity(0.2)), in: RoundedRectangle(cornerRadius: 8))
        } else {
            return self
        }
    }
    
    /// Apply upgrade button glass effect with iOS 18 Liquid Glass
    func applyUpgradeButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(Color.neonBlue.opacity(0.3)), in: RoundedRectangle(cornerRadius: 12))
        } else {
            return self.background(Color.neonBlue)
                .cornerRadius(12)
        }
    }
    
    /// Apply restore button glass effect with iOS 18 Liquid Glass
    func applyRestoreButtonGlassEffect() -> some View {
        if #available(iOS 18.0, *) {
            return self.glassEffect(.regular.tint(.lightGray.opacity(0.1)), in: RoundedRectangle(cornerRadius: 6))
        } else {
            return self
        }
    }
}
