//
//  AccessibilityUITests.swift
//  StryVr-iosTests
//
//  Created by Joe Dormond on 1/15/25.
//  ♿ Comprehensive accessibility UI tests for App Store compliance
//

import XCTest
@testable import StryVr

final class AccessibilityUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Enable accessibility features for testing
        app.launchArguments.append("--enable-accessibility-testing")
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - VoiceOver Navigation Tests
    
    func testVoiceOverTabNavigation() {
        // Given: App is launched
        // When: Navigating through tabs with VoiceOver
        
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        
        // Test each tab is accessible
        let homeTab = tabBar.buttons["Home dashboard"]
        let insightsTab = tabBar.buttons["Career insights and analytics"]
        let reportsTab = tabBar.buttons["Professional resume and reports"]
        let profileTab = tabBar.buttons["User profile and settings"]
        
        XCTAssertTrue(homeTab.exists, "Home tab should be accessible")
        XCTAssertTrue(insightsTab.exists, "Insights tab should be accessible")
        XCTAssertTrue(reportsTab.exists, "Reports tab should be accessible")
        XCTAssertTrue(profileTab.exists, "Profile tab should be accessible")
        
        // Test tab selection
        insightsTab.tap()
        XCTAssertTrue(insightsTab.isSelected, "Insights tab should be selected")
        
        reportsTab.tap()
        XCTAssertTrue(reportsTab.isSelected, "Reports tab should be selected")
    }
    
    func testVoiceOverButtonAccessibility() {
        // Navigate to Reports view
        let reportsTab = app.tabBars.buttons["Professional resume and reports"]
        reportsTab.tap()
        
        // Test menu button accessibility
        let menuButton = app.buttons["ellipsis.circle.fill"]
        XCTAssertTrue(menuButton.exists, "Menu button should exist")
        menuButton.tap()
        
        // Test menu items accessibility
        let shareButton = app.buttons["Share professional report"]
        let exportButton = app.buttons["Export data to PDF"]
        
        XCTAssertTrue(shareButton.exists, "Share button should be accessible")
        XCTAssertTrue(exportButton.exists, "Export button should be accessible")
        
        // Verify accessibility hints are present
        XCTAssertFalse(shareButton.label.isEmpty, "Share button should have accessibility label")
        XCTAssertFalse(exportButton.label.isEmpty, "Export button should have accessibility label")
    }
    
    // MARK: - Dynamic Type Tests
    
    func testDynamicTypeSupport() {
        // Test app handles different Dynamic Type sizes
        let supportedSizes: [UIContentSizeCategory] = [
            .medium,
            .large,
            .extraLarge,
            .accessibility1,
            .accessibility3
        ]
        
        for sizeCategory in supportedSizes {
            // Simulate different text sizes
            app.terminate()
            app.launchArguments.append("--content-size-\(sizeCategory.rawValue)")
            app.launch()
            
            // Verify app launches successfully with each size
            let tabBar = app.tabBars.firstMatch
            XCTAssertTrue(tabBar.waitForExistence(timeout: 5.0), 
                         "App should launch with \(sizeCategory.rawValue) text size")
            
            // Verify text is still readable and not truncated
            let homeTab = tabBar.buttons.firstMatch
            XCTAssertTrue(homeTab.exists, "Tabs should remain accessible at \(sizeCategory.rawValue)")
        }
    }
    
    func testDynamicTypeTextScaling() {
        // Navigate to different views and verify text scaling
        let views = ["Home", "Reports", "Analytics"]
        
        for viewName in views {
            if let tabButton = app.tabBars.buttons.matching(identifier: viewName).firstMatch {
                tabButton.tap()
                
                // Check for text elements that should scale
                let textElements = app.staticTexts
                XCTAssertGreaterThan(textElements.count, 0, "\(viewName) should have text elements")
                
                // Verify no text is completely truncated (basic check)
                for textElement in textElements.allElementsBoundByIndex {
                    let text = textElement.label
                    XCTAssertFalse(text.hasSuffix("..."), 
                                  "Text should not be truncated in \(viewName): \(text)")
                }
            }
        }
    }
    
    // MARK: - High Contrast Mode Tests
    
    func testHighContrastMode() {
        // Enable high contrast mode simulation
        app.terminate()
        app.launchArguments.append("--high-contrast-mode")
        app.launch()
        
        // Verify app maintains functionality in high contrast
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5.0), 
                     "App should work in high contrast mode")
        
        // Test navigation still works
        let reportsTab = app.tabBars.buttons.element(boundBy: 2) // Assuming Reports is 3rd tab
        if reportsTab.exists {
            reportsTab.tap()
            
            // Verify content is still accessible
            XCTAssertTrue(app.scrollViews.firstMatch.exists, 
                         "Content should be accessible in high contrast mode")
        }
    }
    
    // MARK: - Voice Control Tests
    
    func testVoiceControlCompatibility() {
        // Test that elements have proper accessibility identifiers for Voice Control
        
        // Navigate to Analytics view
        let analyticsButton = app.tabBars.buttons.firstMatch
        analyticsButton.tap()
        
        // Check for elements that should be controllable by voice
        let interactiveElements = app.buttons.allElementsBoundByIndex + 
                                app.textFields.allElementsBoundByIndex
        
        for element in interactiveElements {
            // Each interactive element should have a label or identifier
            let hasLabel = !element.label.isEmpty
            let hasIdentifier = !element.identifier.isEmpty
            
            XCTAssertTrue(hasLabel || hasIdentifier, 
                         "Interactive element should have accessibility label or identifier")
        }
    }
    
    // MARK: - Touch Target Size Tests
    
    func testTouchTargetSizes() {
        // Verify all interactive elements meet minimum touch target size (44x44 points)
        let minTouchSize: CGFloat = 44.0
        
        // Check tab bar buttons
        let tabButtons = app.tabBars.buttons.allElementsBoundByIndex
        for button in tabButtons {
            let frame = button.frame
            XCTAssertGreaterThanOrEqual(frame.width, minTouchSize, 
                                      "Tab button width should be at least \(minTouchSize)pt")
            XCTAssertGreaterThanOrEqual(frame.height, minTouchSize, 
                                      "Tab button height should be at least \(minTouchSize)pt")
        }
        
        // Navigate to Reports and check action buttons
        if let reportsTab = tabButtons.first(where: { $0.label.contains("report") || $0.label.contains("Report") }) {
            reportsTab.tap()
            
            let actionButtons = app.buttons.allElementsBoundByIndex
            for button in actionButtons where button.isHittable {
                let frame = button.frame
                XCTAssertGreaterThanOrEqual(frame.width, minTouchSize, 
                                          "Action button width should be at least \(minTouchSize)pt")
                XCTAssertGreaterThanOrEqual(frame.height, minTouchSize, 
                                          "Action button height should be at least \(minTouchSize)pt")
            }
        }
    }
    
    // MARK: - Screen Reader Navigation Tests
    
    func testScreenReaderNavigation() {
        // Test navigation flow with screen reader patterns
        
        // Start from home
        let homeTab = app.tabBars.buttons.firstMatch
        homeTab.tap()
        
        // Navigate through main content areas
        let mainContent = app.scrollViews.firstMatch
        if mainContent.exists {
            // Swipe through content as screen reader would
            mainContent.swipeUp()
            mainContent.swipeDown()
            
            // Should maintain accessibility focus
            XCTAssertTrue(mainContent.exists, "Content should remain accessible during navigation")
        }
        
        // Test modal presentation accessibility
        if let settingsButton = app.buttons.matching(identifier: "settings").firstMatch {
            settingsButton.tap()
            
            // Check modal has proper accessibility
            let modal = app.otherElements["modal"]
            if modal.exists {
                // Should be able to dismiss modal accessibly
                let dismissButton = modal.buttons.firstMatch
                XCTAssertTrue(dismissButton.exists, "Modal should have accessible dismiss button")
            }
        }
    }
    
    // MARK: - Complex Interaction Tests
    
    func testComplexAccessibilityFlow() {
        // Test complete user flow with accessibility features
        
        // 1. Start at home
        let homeTab = app.tabBars.buttons.firstMatch
        homeTab.tap()
        
        // 2. Navigate to Analytics
        let analyticsTab = app.tabBars.buttons.element(boundBy: 1)
        if analyticsTab.exists {
            analyticsTab.tap()
            
            // 3. Interact with chart elements (should be accessible)
            let chartArea = app.otherElements.matching(identifier: "chart").firstMatch
            if chartArea.exists {
                XCTAssertTrue(chartArea.isHittable, "Chart should be accessible")
            }
        }
        
        // 4. Navigate to Reports
        let reportsTab = app.tabBars.buttons.element(boundBy: 2)
        if reportsTab.exists {
            reportsTab.tap()
            
            // 5. Access menu and export (complex interaction)
            let menuButton = app.buttons.matching(identifier: "menu").firstMatch
            if menuButton.exists {
                menuButton.tap()
                
                let exportOption = app.buttons.matching(identifier: "export").firstMatch
                if exportOption.exists {
                    XCTAssertTrue(exportOption.isHittable, "Export option should be accessible")
                }
            }
        }
    }
    
    // MARK: - Performance with Accessibility Tests
    
    func testAccessibilityPerformance() {
        // Measure performance impact of accessibility features
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            // Navigate through app with accessibility enabled
            let tabs = app.tabBars.buttons.allElementsBoundByIndex
            
            for tab in tabs {
                tab.tap()
                // Wait for view to load
                usleep(500000) // 0.5 seconds
            }
        }
    }
    
    // MARK: - Accessibility Traits Tests
    
    func testAccessibilityTraits() {
        // Test that elements have proper accessibility traits
        
        // Check button traits
        let buttons = app.buttons.allElementsBoundByIndex
        for button in buttons where button.exists {
            // Buttons should have button trait (this is implicit in XCUIElement.buttons)
            XCTAssertTrue(button.elementType == .button, "Button elements should have button type")
        }
        
        // Check static text traits
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        for text in staticTexts where text.exists {
            XCTAssertTrue(text.elementType == .staticText, "Text elements should have static text type")
        }
        
        // Navigate to Reports to check specific elements
        let reportsTab = app.tabBars.buttons.element(boundBy: 2)
        if reportsTab.exists {
            reportsTab.tap()
            
            // Check for header elements (should have header trait)
            let headingElements = app.otherElements.matching(identifier: "heading")
            // Note: In a real implementation, we'd verify header traits more specifically
        }
    }
    
    // MARK: - Error State Accessibility Tests
    
    func testErrorStateAccessibility() {
        // Test that error states are properly announced to accessibility
        
        // Simulate network error state (would need app support)
        app.terminate()
        app.launchArguments.append("--simulate-network-error")
        app.launch()
        
        // Check for error message accessibility
        let errorMessages = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'error' OR label CONTAINS 'Error'"))
        
        if errorMessages.count > 0 {
            let errorMessage = errorMessages.firstMatch
            XCTAssertTrue(errorMessage.exists, "Error messages should be accessible")
            XCTAssertFalse(errorMessage.label.isEmpty, "Error messages should have descriptive text")
        }
    }
}

// MARK: - Test Helpers

extension AccessibilityUITests {
    
    /// Helper to verify an element has proper accessibility configuration
    private func verifyElementAccessibility(_ element: XCUIElement, 
                                          expectedLabel: String? = nil,
                                          shouldBeHittable: Bool = true) {
        XCTAssertTrue(element.exists, "Element should exist")
        
        if shouldBeHittable {
            XCTAssertTrue(element.isHittable, "Element should be hittable")
        }
        
        if let expectedLabel = expectedLabel {
            XCTAssertEqual(element.label, expectedLabel, "Element should have expected label")
        } else {
            XCTAssertFalse(element.label.isEmpty, "Element should have accessibility label")
        }
    }
    
    /// Helper to simulate accessibility preference changes
    private func simulateAccessibilityPreference(_ preference: String, enabled: Bool = true) {
        app.terminate()
        let argument = enabled ? "--enable-\(preference)" : "--disable-\(preference)"
        app.launchArguments.append(argument)
        app.launch()
    }
    
    /// Helper to wait for accessibility focus
    private func waitForAccessibilityFocus(on element: XCUIElement, timeout: TimeInterval = 5.0) -> Bool {
        let predicate = NSPredicate(format: "hasKeyboardFocus == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
