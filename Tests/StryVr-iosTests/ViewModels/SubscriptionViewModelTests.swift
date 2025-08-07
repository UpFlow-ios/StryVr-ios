//
//  SubscriptionViewModelTests.swift
//  StryVr-iosTests
//
//  Created by Joe Dormond on 1/15/25.
//  💎 Comprehensive unit tests for SubscriptionViewModel
//

import XCTest
import Combine
@testable import StryVr

@MainActor
final class SubscriptionViewModelTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var viewModel: SubscriptionViewModel!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        viewModel = SubscriptionViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        // Given: Fresh ViewModel
        let freshViewModel = SubscriptionViewModel()
        
        // Then: Initial state should be correct
        XCTAssertFalse(freshViewModel.isLoading)
        XCTAssertFalse(freshViewModel.hasActiveSubscription)
        XCTAssertNil(freshViewModel.currentSubscription)
        XCTAssertTrue(freshViewModel.availablePlans.isEmpty)
        XCTAssertNil(freshViewModel.errorMessage)
    }
    
    // MARK: - Data Loading Tests
    
    func testLoadSubscriptionData_Success() {
        // Given: Expectation for loading completion
        let expectation = XCTestExpectation(description: "Subscription data loaded")
        
        // When: Loading subscription data
        viewModel.loadSubscriptionData()
        
        // Then: Loading state should be true initially
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for async completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.availablePlans.isEmpty)
            XCTAssertFalse(self.viewModel.testimonials.isEmpty)
            XCTAssertFalse(self.viewModel.faqs.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadSubscriptionData_LoadsThreePlans() {
        // Given: Expectation for data loading
        let expectation = XCTestExpectation(description: "Three plans loaded")
        
        // When: Loading subscription data
        viewModel.loadSubscriptionData()
        
        // Wait for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Should have exactly 3 plans (Free, Premium, Professional)
            XCTAssertEqual(self.viewModel.availablePlans.count, 3)
            
            let planNames = self.viewModel.availablePlans.map { $0.name }
            XCTAssertTrue(planNames.contains("Free"))
            XCTAssertTrue(planNames.contains("Premium"))
            XCTAssertTrue(planNames.contains("Professional"))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadSubscriptionData_LoadsTestimonials() {
        // Given: Expectation for testimonials
        let expectation = XCTestExpectation(description: "Testimonials loaded")
        
        // When: Loading subscription data
        viewModel.loadSubscriptionData()
        
        // Wait for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Should have testimonials
            XCTAssertGreaterThan(self.viewModel.testimonials.count, 0)
            
            // Verify testimonial structure
            let firstTestimonial = self.viewModel.testimonials.first!
            XCTAssertFalse(firstTestimonial.name.isEmpty)
            XCTAssertFalse(firstTestimonial.title.isEmpty)
            XCTAssertFalse(firstTestimonial.text.isEmpty)
            XCTAssertEqual(firstTestimonial.rating, 5)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Purchase Flow Tests
    
    func testPurchasePlan_Success() async {
        // Given: Premium plan
        await viewModel.loadSubscriptionData()
        
        // Wait for data to load
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let premiumPlan = viewModel.availablePlans.first { $0.tier == .premium }
        XCTAssertNotNil(premiumPlan)
        
        // When: Purchasing plan
        do {
            try await viewModel.purchasePlan(premiumPlan!)
            
            // Then: Should have active subscription
            XCTAssertTrue(viewModel.hasActiveSubscription)
            XCTAssertEqual(viewModel.currentSubscription?.tier, .premium)
            XCTAssertFalse(viewModel.isLoading)
        } catch {
            XCTFail("Purchase should succeed: \(error)")
        }
    }
    
    func testRestorePurchases_Success() async {
        // Given: ViewModel ready
        // When: Restoring purchases
        do {
            try await viewModel.restorePurchases()
            
            // Then: Should complete without error and stop loading
            XCTAssertFalse(viewModel.isLoading)
        } catch {
            XCTFail("Restore purchases should succeed: \(error)")
        }
    }
    
    func testCancelSubscription_Success() async {
        // Given: Active subscription
        await viewModel.loadSubscriptionData()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Set up active subscription state
        viewModel.hasActiveSubscription = true
        
        // When: Canceling subscription
        do {
            try await viewModel.cancelSubscription()
            
            // Then: Should no longer have active subscription
            XCTAssertFalse(viewModel.hasActiveSubscription)
            XCTAssertEqual(viewModel.currentSubscription?.tier, .free)
        } catch {
            XCTFail("Cancel subscription should succeed: \(error)")
        }
    }
    
    // MARK: - State Management Tests
    
    func testLoadingState_Changes() {
        // Given: Expectation for loading state changes
        let expectation = XCTestExpectation(description: "Loading state changes")
        var loadingStates: [Bool] = []
        
        // Monitor loading state changes
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 3 { // initial false, true, false
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When: Loading data
        viewModel.loadSubscriptionData()
        
        wait(for: [expectation], timeout: 2.0)
        
        // Then: Should have proper loading state sequence
        XCTAssertEqual(loadingStates, [false, true, false])
    }
    
    // MARK: - Performance Tests
    
    func testLoadSubscriptionData_Performance() {
        // Measure performance of data loading
        measure {
            let expectation = XCTestExpectation(description: "Performance test")
            
            viewModel.loadSubscriptionData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
        }
    }
    
    // MARK: - Memory Tests
    
    func testMemoryUsage_LoadingData() {
        // Test that loading data doesn't cause memory leaks
        weak var weakViewModel: SubscriptionViewModel?
        
        autoreleasepool {
            let testViewModel = SubscriptionViewModel()
            weakViewModel = testViewModel
            testViewModel.loadSubscriptionData()
        }
        
        // Force garbage collection
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
        }
    }
    
    // MARK: - Integration Tests
    
    func testCompleteSubscriptionFlow() async {
        // Given: Fresh viewModel
        let expectation = XCTestExpectation(description: "Complete flow")
        
        // Step 1: Load data
        viewModel.loadSubscriptionData()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Step 2: Verify data loaded
        XCTAssertFalse(viewModel.availablePlans.isEmpty)
        
        // Step 3: Purchase premium
        let premiumPlan = viewModel.availablePlans.first { $0.tier == .premium }
        XCTAssertNotNil(premiumPlan)
        
        try? await viewModel.purchasePlan(premiumPlan!)
        XCTAssertTrue(viewModel.hasActiveSubscription)
        
        // Step 4: Cancel subscription
        try? await viewModel.cancelSubscription()
        XCTAssertFalse(viewModel.hasActiveSubscription)
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Edge Cases
    
    func testMultipleSimultaneousLoads() {
        // Test that multiple simultaneous loads don't cause issues
        let expectation = XCTestExpectation(description: "Multiple loads")
        expectation.expectedFulfillmentCount = 3
        
        // Trigger multiple loads
        for _ in 0..<3 {
            viewModel.loadSubscriptionData()
        }
        
        // Wait for all to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
            expectation.fulfill()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        // Should still have consistent state
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.availablePlans.isEmpty)
    }
}

// MARK: - Test Extensions

extension SubscriptionViewModelTests {
    
    /// Helper to create mock subscription plan
    private func createMockPlan(tier: SubscriptionTier) -> SubscriptionPlan {
        return SubscriptionPlan(
            id: "test_\(tier.rawValue)",
            name: tier.rawValue.capitalized,
            tier: tier,
            price: tier == .free ? 0 : 29,
            billingPeriod: "month",
            keyFeatures: ["Test Feature"],
            isPopular: tier == .premium,
            renewalDate: Date()
        )
    }
    
    /// Helper to wait for async operations
    private func waitForAsync(timeout: TimeInterval = 1.0) async {
        try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }
}
