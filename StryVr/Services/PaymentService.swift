//
//  PaymentService.swift
//  StryVr
//
//  Created by Joe Dormond on 3/12/25.
//
import Combine
import Foundation
import OSLog
import StoreKit

/// Manages in-app purchases and subscriptions for StryVr
@MainActor
final class PaymentService: NSObject, ObservableObject, SKPaymentTransactionObserver,
    SKProductsRequestDelegate
{
    static let shared = PaymentService()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr", category: "PaymentService")

    @Published var availableProducts: [SKProduct] = []
    @Published var purchasedProducts: Set<String> = []

    private var restorationCompletion: ((Bool, Error?) -> Void)?

    override private init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    // MARK: - Check Purchase

    /// Checks if a product has already been purchased
    func isProductPurchased(_ productID: String) -> Bool {
        guard !productID.isEmpty else {
            logger.error("❌ Invalid product ID")
            return false
        }
        return purchasedProducts.contains(productID)
    }

    /// Checks if a product ID is valid and available
    func isProductIDValid(_ productID: String) -> Bool {
        return availableProducts.contains(where: { $0.productIdentifier == productID })
    }

    // MARK: - Start Purchase

    /// Initiates the purchase of a product
    func purchaseProduct(_ product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            logger.error("❌ In-App Purchases are disabled.")
            return
        }

        guard isProductIDValid(product.productIdentifier) else {
            logger.error("❌ Attempted to purchase invalid product: \(product.productIdentifier)")
            return
        }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // MARK: - Restore Past Purchases

    /// Restores previously completed purchases
    func restorePurchases(completion: @escaping (Bool, Error?) -> Void) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        // Restoration will be handled in paymentQueue(_:updatedTransactions:)
        // Store completion handler for restoration completion
        restorationCompletion = completion
    }

    // MARK: - Fetch Product Info

    /// Fetches available products from the App Store
    func fetchAvailableProducts(with productIDs: [String]) {
        guard !productIDs.isEmpty else {
            logger.error("❌ Product IDs list is empty")
            return
        }

        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableProducts = response.products
        logger.info("✅ Retrieved \(self.availableProducts.count) products from App Store")
        if response.invalidProductIdentifiers.count > 0 {
            logger.warning("⚠️ Invalid Product IDs: \(response.invalidProductIdentifiers)")
        }
    }

    func request(_: SKRequest, didFailWithError error: Error) {
        logger.error("❌ Product request failed: \(error.localizedDescription)")
    }

    // MARK: - Transaction Handling

    /// Handles updates to payment transactions
    func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    logger.error("❌ Purchase failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        let productID = transaction.payment.productIdentifier
        purchasedProducts.insert(productID)
        logger.info("💰 Purchase completed: \(productID)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        let productID = transaction.payment.productIdentifier
        purchasedProducts.insert(productID)
        logger.info("♻️ Purchase restored: \(productID)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    // MARK: - Restoration Completion

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        logger.info("✅ Restoration completed successfully")
        restorationCompletion?(true, nil)
        restorationCompletion = nil
    }

    func paymentQueue(
        _ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error
    ) {
        logger.error("❌ Restoration failed: \(error.localizedDescription)")
        restorationCompletion?(false, error)
        restorationCompletion = nil
    }
}
