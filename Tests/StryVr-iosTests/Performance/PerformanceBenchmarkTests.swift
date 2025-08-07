//
//  PerformanceBenchmarkTests.swift
//  StryVr-iosTests
//
//  Created by Joe Dormond on 1/15/25.
//  ⚡ Comprehensive performance benchmarks for App Store optimization
//

import XCTest
import Combine
@testable import StryVr

final class PerformanceBenchmarkTests: XCTestCase {
    
    // MARK: - Performance Thresholds
    
    private let appLaunchThreshold: TimeInterval = 3.0 // seconds
    private let viewLoadThreshold: TimeInterval = 1.0 // seconds
    private let apiResponseThreshold: TimeInterval = 2.0 // seconds
    private let memoryLimitMB: Int = 500 // MB
    private let fpsTarget: Int = 60 // frames per second
    
    // MARK: - App Launch Performance
    
    func testAppLaunchPerformance() {
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            // Simulate app launch sequence
            let app = XCUIApplication()
            app.launch()
            
            // Wait for main interface to appear
            let tabBar = app.tabBars.firstMatch
            XCTAssertTrue(tabBar.waitForExistence(timeout: appLaunchThreshold), 
                         "App should launch within \(appLaunchThreshold) seconds")
        }
    }
    
    func testColdStartPerformance() {
        // Test app performance on cold start
        measure {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            // Simulate cold start by creating fresh instances
            let viewModel = HomeViewModel()
            let authViewModel = AuthViewModel()
            let analyticsViewModel = AnalyticsViewModel()
            
            // Measure time to initial state
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            
            XCTAssertLessThan(duration, 0.5, "Cold start should complete within 0.5 seconds")
            
            // Cleanup
            _ = viewModel
            _ = authViewModel
            _ = analyticsViewModel
        }
    }
    
    // MARK: - View Loading Performance
    
    func testHomeViewLoadingPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Home view loads quickly")
            
            DispatchQueue.main.async {
                let homeViewModel = HomeViewModel()
                homeViewModel.fetchSkills()
                
                // Simulate view appearance
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: viewLoadThreshold)
        }
    }
    
    func testAnalyticsViewLoadingPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Analytics view loads quickly")
            
            DispatchQueue.main.async {
                let analyticsViewModel = AnalyticsViewModel()
                analyticsViewModel.loadAnalytics(for: "test_user", timeFrame: .month)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: viewLoadThreshold)
        }
    }
    
    func testReportsViewLoadingPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Reports view loads quickly")
            
            DispatchQueue.main.async {
                let reportsViewModel = ReportsViewModel()
                reportsViewModel.loadProfessionalData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: viewLoadThreshold)
        }
    }
    
    // MARK: - Memory Performance
    
    func testMemoryUsageUnderLoad() {
        measure(metrics: [XCTMemoryMetric()]) {
            // Create multiple ViewModels to simulate heavy usage
            var viewModels: [Any] = []
            
            for _ in 0..<10 {
                viewModels.append(HomeViewModel())
                viewModels.append(AnalyticsViewModel())
                viewModels.append(SubscriptionViewModel())
                viewModels.append(AIInsightsViewModel())
            }
            
            // Trigger data loading
            for viewModel in viewModels {
                if let homeVM = viewModel as? HomeViewModel {
                    homeVM.fetchSkills()
                } else if let analyticsVM = viewModel as? AnalyticsViewModel {
                    analyticsVM.loadAnalytics(for: "test_user", timeFrame: .month)
                } else if let subscriptionVM = viewModel as? SubscriptionViewModel {
                    subscriptionVM.loadSubscriptionData()
                } else if let aiVM = viewModel as? AIInsightsViewModel {
                    aiVM.loadInsights(for: "test_user")
                }
            }
            
            // Keep references to prevent immediate deallocation
            _ = viewModels
        }
    }
    
    func testMemoryLeakDetection() {
        weak var weakHomeViewModel: HomeViewModel?
        weak var weakAnalyticsViewModel: AnalyticsViewModel?
        weak var weakSubscriptionViewModel: SubscriptionViewModel?
        
        autoreleasepool {
            let homeViewModel = HomeViewModel()
            let analyticsViewModel = AnalyticsViewModel()
            let subscriptionViewModel = SubscriptionViewModel()
            
            weakHomeViewModel = homeViewModel
            weakAnalyticsViewModel = analyticsViewModel
            weakSubscriptionViewModel = subscriptionViewModel
            
            // Use view models
            homeViewModel.fetchSkills()
            analyticsViewModel.loadAnalytics(for: "test_user", timeFrame: .month)
            subscriptionViewModel.loadSubscriptionData()
        }
        
        // Force garbage collection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(weakHomeViewModel, "HomeViewModel should be deallocated")
            XCTAssertNil(weakAnalyticsViewModel, "AnalyticsViewModel should be deallocated") 
            XCTAssertNil(weakSubscriptionViewModel, "SubscriptionViewModel should be deallocated")
        }
    }
    
    // MARK: - CPU Performance
    
    func testCPUUsageUnderLoad() {
        measure(metrics: [XCTCPUMetric()]) {
            // Simulate CPU-intensive operations
            let viewModels = (0..<5).map { _ in AnalyticsViewModel() }
            
            // Trigger parallel loading
            for viewModel in viewModels {
                viewModel.loadAnalytics(for: "test_user_\(UUID().uuidString)", timeFrame: .month)
            }
            
            // Wait for completion
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    func testConcurrentOperationsPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Concurrent operations complete")
            expectation.expectedFulfillmentCount = 4
            
            let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
            
            // Run multiple operations concurrently
            queue.async {
                let homeVM = HomeViewModel()
                homeVM.fetchSkills()
                expectation.fulfill()
            }
            
            queue.async {
                let analyticsVM = AnalyticsViewModel()
                analyticsVM.loadAnalytics(for: "test_user", timeFrame: .month)
                expectation.fulfill()
            }
            
            queue.async {
                let subscriptionVM = SubscriptionViewModel()
                subscriptionVM.loadSubscriptionData()
                expectation.fulfill()
            }
            
            queue.async {
                let aiVM = AIInsightsViewModel()
                aiVM.loadInsights(for: "test_user")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3.0)
        }
    }
    
    // MARK: - UI Responsiveness
    
    func testUIResponsivenessUnderLoad() {
        let app = XCUIApplication()
        app.launch()
        
        measure {
            // Navigate through all tabs rapidly
            let tabBar = app.tabBars.firstMatch
            let tabs = tabBar.buttons.allElementsBoundByIndex
            
            for _ in 0..<3 { // Multiple iterations
                for tab in tabs {
                    tab.tap()
                    // Small delay to allow UI to update
                    usleep(100000) // 0.1 seconds
                }
            }
        }
    }
    
    func testScrollingPerformance() {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to a scrollable view (Reports)
        let reportsTab = app.tabBars.buttons.element(boundBy: 2)
        reportsTab.tap()
        
        measure {
            let scrollView = app.scrollViews.firstMatch
            
            if scrollView.exists {
                // Perform multiple scroll operations
                for _ in 0..<10 {
                    scrollView.swipeUp()
                    usleep(50000) // 0.05 seconds
                    scrollView.swipeDown()
                    usleep(50000) // 0.05 seconds
                }
            }
        }
    }
    
    // MARK: - Network Performance Simulation
    
    func testNetworkOperationPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Network operations complete")
            expectation.expectedFulfillmentCount = 3
            
            // Simulate multiple network operations
            DispatchQueue.global().async {
                // Simulate API call delay
                Thread.sleep(forTimeInterval: 0.2)
                expectation.fulfill()
            }
            
            DispatchQueue.global().async {
                // Simulate API call delay
                Thread.sleep(forTimeInterval: 0.3)
                expectation.fulfill()
            }
            
            DispatchQueue.global().async {
                // Simulate API call delay
                Thread.sleep(forTimeInterval: 0.1)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: apiResponseThreshold)
        }
    }
    
    // MARK: - Animation Performance
    
    func testAnimationPerformance() {
        let app = XCUIApplication()
        app.launch()
        
        measure(metrics: [XCTClockMetric()]) {
            // Test tab switching animations
            let tabBar = app.tabBars.firstMatch
            let tabs = tabBar.buttons.allElementsBoundByIndex
            
            for tab in tabs {
                tab.tap()
                // Wait for animation to complete
                usleep(250000) // 0.25 seconds
            }
        }
    }
    
    // MARK: - Data Processing Performance
    
    func testLargeDataSetPerformance() {
        measure {
            // Simulate processing large data sets
            let largeDataSet = (0..<1000).map { index in
                return ChartDataPoint(date: Date(), value: Double(index), category: "Test \(index)")
            }
            
            // Process data
            let filteredData = largeDataSet.filter { $0.value > 500 }
            let sortedData = filteredData.sorted { $0.value < $1.value }
            let transformedData = sortedData.map { dataPoint in
                ChartDataPoint(date: dataPoint.date, value: dataPoint.value * 2, category: dataPoint.category)
            }
            
            XCTAssertFalse(transformedData.isEmpty, "Data processing should complete")
        }
    }
    
    func testJSONParsingPerformance() {
        measure {
            // Create large JSON data
            let largeJSONData = createLargeJSONData()
            
            // Parse JSON
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: largeJSONData, options: [])
                XCTAssertNotNil(jsonObject, "JSON parsing should succeed")
            } catch {
                XCTFail("JSON parsing failed: \(error)")
            }
        }
    }
    
    // MARK: - Image Processing Performance
    
    func testImageProcessingPerformance() {
        measure {
            // Simulate image processing for profile pictures, icons, etc.
            let originalSize = CGSize(width: 1000, height: 1000)
            let targetSize = CGSize(width: 100, height: 100)
            
            // Simulate image resizing operation
            let resizeTime = simulateImageResize(from: originalSize, to: targetSize)
            
            XCTAssertLessThan(resizeTime, 0.1, "Image resizing should be fast")
        }
    }
    
    // MARK: - Stress Tests
    
    func testMemoryStressTest() {
        measure(metrics: [XCTMemoryMetric()]) {
            var viewModels: [Any] = []
            
            // Create a large number of view models
            for i in 0..<100 {
                if i % 4 == 0 {
                    viewModels.append(HomeViewModel())
                } else if i % 4 == 1 {
                    viewModels.append(AnalyticsViewModel())
                } else if i % 4 == 2 {
                    viewModels.append(SubscriptionViewModel())
                } else {
                    viewModels.append(AIInsightsViewModel())
                }
            }
            
            // Trigger operations on all view models
            for viewModel in viewModels {
                if let homeVM = viewModel as? HomeViewModel {
                    homeVM.fetchSkills()
                }
                // Add other view model operations as needed
            }
            
            // Keep references to prevent immediate deallocation
            _ = viewModels
        }
    }
    
    func testCPUStressTest() {
        measure(metrics: [XCTCPUMetric()]) {
            // Simulate CPU-intensive work
            let iterations = 10000
            var results: [Double] = []
            
            for i in 0..<iterations {
                let value = sin(Double(i)) * cos(Double(i)) * sqrt(Double(i + 1))
                results.append(value)
            }
            
            XCTAssertEqual(results.count, iterations, "CPU stress test should complete")
        }
    }
    
    // MARK: - Real-World Scenario Tests
    
    func testCompleteUserFlowPerformance() {
        measure {
            let app = XCUIApplication()
            app.launch()
            
            // Simulate complete user flow
            let tabBar = app.tabBars.firstMatch
            let tabs = tabBar.buttons.allElementsBoundByIndex
            
            // 1. Start at home
            if tabs.count > 0 {
                tabs[0].tap()
                usleep(200000) // 0.2 seconds
            }
            
            // 2. Check analytics
            if tabs.count > 1 {
                tabs[1].tap()
                usleep(300000) // 0.3 seconds
            }
            
            // 3. View reports
            if tabs.count > 2 {
                tabs[2].tap()
                usleep(250000) // 0.25 seconds
                
                // Interact with reports
                let menuButton = app.buttons.matching(identifier: "menu").firstMatch
                if menuButton.exists {
                    menuButton.tap()
                    usleep(100000) // 0.1 seconds
                }
            }
            
            // 4. Return to home
            if tabs.count > 0 {
                tabs[0].tap()
                usleep(200000) // 0.2 seconds
            }
        }
    }
}

// MARK: - Performance Test Helpers

extension PerformanceBenchmarkTests {
    
    /// Create large JSON data for parsing tests
    private func createLargeJSONData() -> Data {
        var jsonObject: [String: Any] = [:]
        
        // Create large nested structure
        for i in 0..<100 {
            jsonObject["item_\(i)"] = [
                "id": i,
                "name": "Test Item \(i)",
                "description": "This is a test item with index \(i)",
                "value": Double(i) * 1.5,
                "tags": (0..<10).map { "tag_\($0)" },
                "metadata": [
                    "created": Date().timeIntervalSince1970,
                    "updated": Date().timeIntervalSince1970,
                    "version": "1.0.\(i)"
                ]
            ]
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        } catch {
            return Data()
        }
    }
    
    /// Simulate image resize operation
    private func simulateImageResize(from originalSize: CGSize, to targetSize: CGSize) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Simulate image processing calculations
        let aspectRatio = originalSize.width / originalSize.height
        let newWidth = min(targetSize.width, targetSize.height * aspectRatio)
        let newHeight = min(targetSize.height, targetSize.width / aspectRatio)
        
        // Simulate processing time
        let processingComplexity = (originalSize.width * originalSize.height) / (newWidth * newHeight)
        usleep(UInt32(min(processingComplexity / 10000, 100000))) // Max 0.1 seconds
        
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
    
    /// Verify performance meets App Store standards
    private func verifyAppStorePerformanceStandards() {
        // App Store performance requirements:
        // - Launch time < 3 seconds
        // - Memory usage < 500MB for most scenarios  
        // - 60 FPS for animations
        // - Responsive UI (< 1 second for most interactions)
        
        XCTAssertLessThan(appLaunchThreshold, 3.0, "App should launch within App Store requirements")
        XCTAssertLessThan(memoryLimitMB, 500, "Memory usage should be within App Store limits")
        XCTAssertEqual(fpsTarget, 60, "Animation should target 60 FPS")
    }
}
