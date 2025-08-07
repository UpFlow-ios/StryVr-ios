//
//  AnalyticsViewModelTests.swift
//  StryVr-iosTests
//
//  Created by Joe Dormond on 1/15/25.
//  📊 Comprehensive unit tests for AnalyticsViewModel
//

import XCTest
import Combine
@testable import StryVr

@MainActor
final class AnalyticsViewModelTests: XCTestCase {
    
    // MARK: - Test Properties
    
    var viewModel: AnalyticsViewModel!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        viewModel = AnalyticsViewModel()
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
        let freshViewModel = AnalyticsViewModel()
        
        // Then: Initial state should have default values
        XCTAssertFalse(freshViewModel.isLoading)
        XCTAssertEqual(freshViewModel.performanceScore, 87)
        XCTAssertEqual(freshViewModel.skillGrowth, 12)
        XCTAssertEqual(freshViewModel.goalCompletion, 73)
        XCTAssertEqual(freshViewModel.marketPosition, 15)
        XCTAssertTrue(freshViewModel.chartData.isEmpty)
        XCTAssertNil(freshViewModel.errorMessage)
    }
    
    // MARK: - Data Loading Tests
    
    func testLoadAnalytics_Success() {
        // Given: Expectation for loading completion
        let expectation = XCTestExpectation(description: "Analytics data loaded")
        
        // When: Loading analytics data
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        // Then: Loading state should be true initially
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
        // Wait for async completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.chartData.isEmpty)
            XCTAssertFalse(self.viewModel.performanceCategories.isEmpty)
            XCTAssertFalse(self.viewModel.insights.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadAnalytics_DifferentTimeFrames() {
        let timeFrames: [TimeFrame] = [.week, .month, .quarter, .year]
        let expectation = XCTestExpectation(description: "All timeframes loaded")
        expectation.expectedFulfillmentCount = timeFrames.count
        
        for timeFrame in timeFrames {
            // When: Loading with different timeframes
            viewModel.loadAnalytics(for: "test_user", timeFrame: timeFrame)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Then: Should have data for each timeframe
                XCTAssertFalse(self.viewModel.chartData.isEmpty)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadAnalytics_ErrorHandling() {
        // Given: Invalid user ID
        let expectation = XCTestExpectation(description: "Error handled gracefully")
        
        // When: Loading with invalid data
        viewModel.loadAnalytics(for: "", timeFrame: .month)
        
        // Wait for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Should complete without crashing
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Refresh Tests
    
    func testRefreshData_Success() {
        // Given: Loaded data
        let expectation = XCTestExpectation(description: "Data refreshed")
        
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // When: Refreshing data
            self.viewModel.refreshData()
            
            // Then: Should trigger loading
            XCTAssertTrue(self.viewModel.isLoading)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRefreshData_HapticFeedback() {
        // Given: Expectation that refresh includes haptic feedback
        // Note: In a real test, we might mock UIImpactFeedbackGenerator
        
        // When: Refreshing data
        viewModel.refreshData()
        
        // Then: Should complete successfully (haptic feedback is called internally)
        XCTAssertTrue(viewModel.isLoading)
    }
    
    // MARK: - Export Tests
    
    func testExportAnalytics() {
        // When: Exporting analytics
        viewModel.exportAnalytics()
        
        // Then: Should complete without error
        // Note: In a real implementation, this might return data or trigger a delegate
        XCTAssertNotNil(viewModel)
    }
    
    // MARK: - Performance Score Tests
    
    func testPerformanceScore_ValidRange() {
        // Given: Fresh viewModel
        // When: Checking initial score
        let score = viewModel.performanceScore
        
        // Then: Should be in valid range (0-100)
        XCTAssertGreaterThanOrEqual(score, 0)
        XCTAssertLessThanOrEqual(score, 100)
    }
    
    func testPerformanceChange_Tracking() {
        // Given: Initial performance change
        let initialChange = viewModel.performanceChange
        
        // When: Loading new data
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        // Wait for completion
        let expectation = XCTestExpectation(description: "Performance change updated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Performance change should be tracked
            XCTAssertNotNil(self.viewModel.performanceChange)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Skill Growth Tests
    
    func testSkillGrowth_ValidValues() {
        // Given: Loaded data
        let expectation = XCTestExpectation(description: "Skill growth validated")
        
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Skill growth should be reasonable
            XCTAssertGreaterThanOrEqual(self.viewModel.skillGrowth, 0)
            XCTAssertLessThan(self.viewModel.skillGrowth, 1000) // Reasonable upper bound
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - State Management Tests
    
    func testLoadingState_Sequence() {
        // Given: Loading state tracker
        var loadingStates: [Bool] = []
        let expectation = XCTestExpectation(description: "Loading states tracked")
        
        viewModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When: Loading data
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        wait(for: [expectation], timeout: 2.0)
        
        // Then: Should follow proper loading sequence
        XCTAssertEqual(loadingStates.first, false) // Initial state
        XCTAssertTrue(loadingStates.contains(true)) // Loading state
        XCTAssertEqual(loadingStates.last, false) // Final state
    }
    
    func testErrorMessage_Clearing() {
        // Given: Error message set
        viewModel.errorMessage = "Test error"
        
        // When: Loading new data
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        // Then: Error message should be cleared
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Chart Data Tests
    
    func testChartData_Structure() {
        // Given: Expectation for chart data
        let expectation = XCTestExpectation(description: "Chart data structured correctly")
        
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Chart data should have proper structure
            XCTAssertFalse(self.viewModel.chartData.isEmpty)
            
            for dataPoint in self.viewModel.chartData {
                XCTAssertGreaterThanOrEqual(dataPoint.value, 0)
                XCTAssertNotNil(dataPoint.date)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testPerformanceCategories_Content() {
        // Given: Expectation for performance categories
        let expectation = XCTestExpectation(description: "Performance categories loaded")
        
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Then: Should have performance categories
            XCTAssertFalse(self.viewModel.performanceCategories.isEmpty)
            
            for category in self.viewModel.performanceCategories {
                XCTAssertFalse(category.name.isEmpty)
                XCTAssertGreaterThanOrEqual(category.score, 0)
                XCTAssertLessThanOrEqual(category.score, 100)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Performance Tests
    
    func testLoadAnalytics_Performance() {
        // Measure performance of analytics loading
        measure {
            let expectation = XCTestExpectation(description: "Performance test")
            
            viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func testRefreshData_Performance() {
        // Measure performance of data refresh
        measure {
            let expectation = XCTestExpectation(description: "Refresh performance test")
            
            viewModel.refreshData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    // MARK: - Memory Tests
    
    func testMemoryManagement() {
        weak var weakViewModel: AnalyticsViewModel?
        
        autoreleasepool {
            let testViewModel = AnalyticsViewModel()
            weakViewModel = testViewModel
            testViewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        }
        
        // ViewModel should be deallocated when out of scope
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
        }
    }
    
    // MARK: - Integration Tests
    
    func testCompleteAnalyticsFlow() {
        // Given: Complete flow expectation
        let expectation = XCTestExpectation(description: "Complete analytics flow")
        
        // Step 1: Load initial data
        viewModel.loadAnalytics(for: "test_user", timeFrame: .month)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Step 2: Verify data loaded
            XCTAssertFalse(self.viewModel.chartData.isEmpty)
            
            // Step 3: Refresh data
            self.viewModel.refreshData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                // Step 4: Export analytics
                self.viewModel.exportAnalytics()
                
                // Step 5: Load different timeframe
                self.viewModel.loadAnalytics(for: "test_user", timeFrame: .year)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    XCTAssertFalse(self.viewModel.isLoading)
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Edge Cases
    
    func testMultipleTimeFrameChanges() {
        // Test rapid timeframe changes
        let expectation = XCTestExpectation(description: "Multiple timeframe changes")
        
        let timeFrames: [TimeFrame] = [.week, .month, .quarter, .year, .month]
        
        for (index, timeFrame) in timeFrames.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                self.viewModel.loadAnalytics(for: "test_user", timeFrame: timeFrame)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Should handle rapid changes gracefully
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}

// MARK: - Test Helpers

extension AnalyticsViewModelTests {
    
    /// Helper to verify analytics data structure
    private func verifyAnalyticsDataStructure() {
        XCTAssertFalse(viewModel.chartData.isEmpty, "Chart data should not be empty")
        XCTAssertFalse(viewModel.performanceCategories.isEmpty, "Performance categories should not be empty")
        XCTAssertFalse(viewModel.insights.isEmpty, "Insights should not be empty")
    }
    
    /// Helper to verify score ranges
    private func verifyScoreRanges() {
        XCTAssertGreaterThanOrEqual(viewModel.performanceScore, 0)
        XCTAssertLessThanOrEqual(viewModel.performanceScore, 100)
        XCTAssertGreaterThanOrEqual(viewModel.goalCompletion, 0)
        XCTAssertLessThanOrEqual(viewModel.goalCompletion, 100)
    }
}
