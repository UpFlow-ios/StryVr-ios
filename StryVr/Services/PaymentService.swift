//
//  PaymentService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Foundation
import StoreKit
import os.log

/// Manages in-app purchases and subscriptions for StryVr
final class PaymentService: NSObject, ObservableObject, SKPaymentTransactionObserver {

    static let shared = PaymentService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PaymentService")

    @Published var purchasedProducts: Set<String> = []

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    /// Checks if the user has an active subscription or purchased product
    /// - Parameter productID: The product identifier to check.
    /// - Returns: A boolean indicating if the product is purchased.
    func isProductPurchased(_ productID: String) -> Bool {
        return purchasedProducts.contains(productID)
    }

    /// Starts the purchase process for a specific product
    /// - Parameter product: The product to be purchased.
    func purchaseProduct(_ product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            logger.error("In-App Purchases are disabled.")
            return
        }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    /// Restores previous purchases (used when reinstalling the app)
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    /// Handles payment transaction updates
    /// - Parameters:
    ///   - queue: The payment queue.
    ///   - transactions: The list of updated transactions.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    logger.error("Purchase failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    /// Completes a successful purchase and saves it
    /// - Parameter transaction: The completed transaction.
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        let productID = transaction.payment.productIdentifier
        purchasedProducts.insert(productID)
        logger.info("Purchase successful: \(productID)")

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    /// Restores a previous purchase
    /// - Parameter transaction: The restored transaction.
    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        let productID = transaction.payment.productIdentifier
        purchasedProducts.insert(productID)
        logger.info("Purchase restored: \(productID)")

        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
