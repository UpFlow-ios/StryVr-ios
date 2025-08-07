//
//  AccessibilityManager.swift
//  StryVr
//
//  Created by Joe Dormond on 1/15/25.
//  ♿ Professional-Grade Accessibility Manager for App Store Excellence
//

import SwiftUI

/// Comprehensive accessibility manager providing VoiceOver, Dynamic Type, and enhanced UX support
struct AccessibilityManager {
    
    // MARK: - Dynamic Type Configuration
    
    /// Professional Dynamic Type scaling for business app accessibility
    enum DynamicTypeRange {
        case standard
        case accessibility
        case full
        
        var range: ClosedRange<DynamicTypeSize> {
            switch self {
            case .standard:
                return .large ... .xxLarge
            case .accessibility:
                return .large ... .accessibility3
            case .full:
                return .xSmall ... .accessibility5
            }
        }
    }
    
    // MARK: - Accessibility Traits
    
    /// Common accessibility traits for StryVr UI elements
    enum StryVrAccessibilityTrait {
        case primaryButton
        case secondaryButton
        case navigationButton
        case dataCard
        case chartElement
        case progressIndicator
        case inputField
        case headerText
        case bodyText
        case alertMessage
        
        var traits: AccessibilityTraits {
            switch self {
            case .primaryButton:
                return [.isButton, .keyboardKey]
            case .secondaryButton:
                return [.isButton]
            case .navigationButton:
                return [.isButton, .keyboardKey]
            case .dataCard:
                return [.isButton, .playsSound]
            case .chartElement:
                return [.isImage, .allowsDirectInteraction]
            case .progressIndicator:
                return [.isImage, .updatesFrequently]
            case .inputField:
                return [.isSearchField]
            case .headerText:
                return [.isHeader]
            case .bodyText:
                return [.isStaticText]
            case .alertMessage:
                return [.isStaticText, .playsSound]
            }
        }
    }
    
    // MARK: - VoiceOver Labels
    
    /// Professional VoiceOver labels for StryVr features
    struct VoiceOverLabels {
        
        // Navigation
        static let homeTab = "Home dashboard"
        static let insightsTab = "Career insights and analytics"
        static let reportsTab = "Professional resume and reports"
        static let profileTab = "User profile and settings"
        
        // AI Features
        static let aiInsightsCard = "AI-powered career recommendation"
        static let skillAssessment = "Skill level assessment"
        static let careerPathSuggestion = "Personalized career path suggestion"
        static let performanceMetric = "Performance metric indicator"
        
        // Data Visualization
        static let skillChart = "Skill progression chart"
        static let performanceChart = "Performance analytics chart"
        static let teamChart = "Team health analytics"
        static let progressBar = "Progress indicator"
        
        // Actions
        static let upgradeButton = "Upgrade to premium subscription"
        static let shareButton = "Share professional report"
        static let exportButton = "Export data to PDF"
        static let refreshButton = "Refresh analytics data"
        static let settingsButton = "Open settings menu"
        
        // Status Indicators
        static let verifiedBadge = "HR verified information"
        static let premiumBadge = "Premium feature"
        static let loadingIndicator = "Loading content"
        static let errorMessage = "Error notification"
        static let successMessage = "Success confirmation"
    }
    
    // MARK: - VoiceOver Hints
    
    /// Professional VoiceOver hints providing context and instructions
    struct VoiceOverHints {
        
        // Navigation
        static let homeTab = "Double tap to view your professional dashboard"
        static let insightsTab = "Double tap to explore AI-powered career insights"
        static let reportsTab = "Double tap to access your verified professional resume"
        static let profileTab = "Double tap to manage your profile and settings"
        
        // Interactive Elements
        static let aiInsightsCard = "Double tap to view detailed recommendation"
        static let skillChart = "Swipe right to hear detailed skill breakdown"
        static let upgradeButton = "Double tap to upgrade your subscription"
        static let shareButton = "Double tap to share your professional achievements"
        static let exportButton = "Double tap to export your data as PDF"
        
        // Forms and Inputs
        static let textField = "Double tap to edit text"
        static let secureField = "Double tap to enter secure information"
        static let picker = "Double tap to select from options"
        static let toggle = "Double tap to toggle setting"
        
        // Data Elements
        static let dataCard = "Double tap to view detailed information"
        static let chartElement = "Swipe to explore data points"
        static let progressIndicator = "Shows current progress level"
    }
}

// MARK: - View Extensions for Accessibility

extension View {
    
    /// Apply professional Dynamic Type support with business app constraints
    func professionalDynamicType(_ range: AccessibilityManager.DynamicTypeRange = .accessibility) -> some View {
        self.dynamicTypeSize(range.range)
    }
    
    /// Apply StryVr accessibility traits and labels
    func stryVrAccessibility(
        trait: AccessibilityManager.StryVrAccessibilityTrait,
        label: String,
        hint: String? = nil,
        value: String? = nil
    ) -> some View {
        self
            .accessibilityAddTraits(trait.traits)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
    }
    
    /// Professional button accessibility with enhanced VoiceOver support
    func professionalButtonAccessibility(
        label: String,
        hint: String,
        isPrimary: Bool = true
    ) -> some View {
        self.stryVrAccessibility(
            trait: isPrimary ? .primaryButton : .secondaryButton,
            label: label,
            hint: hint
        )
    }
    
    /// Chart and data visualization accessibility
    func chartAccessibility(
        label: String,
        hint: String,
        dataDescription: String
    ) -> some View {
        self
            .stryVrAccessibility(
                trait: .chartElement,
                label: label,
                hint: hint,
                value: dataDescription
            )
            .accessibilityAction(named: "Describe Data") {
                // Custom action to provide detailed data description
            }
    }
    
    /// Navigation accessibility for tab bars and navigation elements
    func navigationAccessibility(
        label: String,
        hint: String,
        isSelected: Bool = false
    ) -> some View {
        self
            .stryVrAccessibility(
                trait: .navigationButton,
                label: label,
                hint: hint
            )
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    /// Progress and status accessibility
    func progressAccessibility(
        label: String,
        value: Double,
        maxValue: Double = 100.0
    ) -> some View {
        let percentage = Int((value / maxValue) * 100)
        return self
            .stryVrAccessibility(
                trait: .progressIndicator,
                label: label,
                hint: "Progress indicator showing current level",
                value: "\(percentage) percent complete"
            )
            .accessibilityAdjustableAction { direction in
                // Allow VoiceOver users to adjust values if applicable
            }
    }
    
    /// Professional card accessibility for data cards and content blocks
    func professionalCardAccessibility(
        title: String,
        description: String,
        action: String? = nil
    ) -> some View {
        let hint = action ?? "Double tap to view details"
        return self.stryVrAccessibility(
            trait: .dataCard,
            label: "\(title): \(description)",
            hint: hint
        )
    }
    
    /// Header text accessibility with proper hierarchy
    func headerAccessibility(
        level: Int = 1,
        text: String
    ) -> some View {
        self
            .stryVrAccessibility(
                trait: .headerText,
                label: "Heading level \(level): \(text)",
                hint: "Main section header"
            )
            .accessibilityHeading(.h1) // SwiftUI heading semantics
    }
    
    /// Enhanced text accessibility with context
    func professionalTextAccessibility(
        text: String,
        context: String? = nil
    ) -> some View {
        let fullLabel = context != nil ? "\(context!): \(text)" : text
        return self.stryVrAccessibility(
            trait: .bodyText,
            label: fullLabel,
            hint: "Informational text"
        )
    }
}

// MARK: - Accessibility Environment Support

/// Environment key for accessibility preferences
struct AccessibilityPreferencesKey: EnvironmentKey {
    static let defaultValue = AccessibilityPreferences()
}

extension EnvironmentValues {
    var accessibilityPreferences: AccessibilityPreferences {
        get { self[AccessibilityPreferencesKey.self] }
        set { self[AccessibilityPreferencesKey.self] = newValue }
    }
}

/// User accessibility preferences for the app
struct AccessibilityPreferences: ObservableObject {
    @Published var reduceMotion: Bool = false
    @Published var increaseContrast: Bool = false
    @Published var voiceOverEnabled: Bool = false
    @Published var dynamicTypeEnabled: Bool = true
    @Published var hapticFeedbackEnabled: Bool = true
    
    init() {
        // Initialize with system accessibility settings
        self.reduceMotion = UIAccessibility.isReduceMotionEnabled
        self.increaseContrast = UIAccessibility.isDarkerSystemColorsEnabled
        self.voiceOverEnabled = UIAccessibility.isVoiceOverRunning
    }
    
    /// Update preferences based on system changes
    func updateFromSystem() {
        reduceMotion = UIAccessibility.isReduceMotionEnabled
        increaseContrast = UIAccessibility.isDarkerSystemColorsEnabled
        voiceOverEnabled = UIAccessibility.isVoiceOverRunning
    }
}

// MARK: - Accessibility Testing Support

/// Accessibility testing utilities for development and QA
struct AccessibilityTesting {
    
    /// Validate accessibility implementation for a view
    static func validateAccessibility(for view: AnyView) -> [AccessibilityValidationResult] {
        var results: [AccessibilityValidationResult] = []
        
        // This would contain validation logic for:
        // - Missing accessibility labels
        // - Insufficient contrast ratios
        // - Missing VoiceOver hints
        // - Dynamic Type compatibility
        // - Touch target size compliance
        
        return results
    }
    
    /// Accessibility validation result
    struct AccessibilityValidationResult {
        let type: ValidationType
        let message: String
        let severity: Severity
        
        enum ValidationType {
            case missingLabel
            case insufficientContrast
            case smallTouchTarget
            case missingHint
            case dynamicTypeIssue
        }
        
        enum Severity {
            case error
            case warning
            case suggestion
        }
    }
}
