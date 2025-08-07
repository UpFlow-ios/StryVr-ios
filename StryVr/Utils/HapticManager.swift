//
//  HapticManager.swift
//  StryVr
//
//  Created by Joe Dormond on 8/1/25.
//  📳 Haptic feedback utilities for enhanced user experience
//

import UIKit

/// Manages haptic feedback throughout the app for consistent user experience
class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // MARK: - Impact Feedback
    
    /// Light impact feedback for subtle interactions
    func lightImpact() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    /// Medium impact feedback for standard interactions
    func mediumImpact() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    /// Heavy impact feedback for important actions
    func heavyImpact() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Notification Feedback
    
    /// Success notification feedback
    func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    /// Warning notification feedback
    func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    /// Error notification feedback
    func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback
    
    /// Selection change feedback
    func selectionChanged() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    // MARK: - Custom Patterns
    
    /// Celebration pattern for achievements
    func celebrate() {
        DispatchQueue.main.async {
            self.success()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.lightImpact()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.lightImpact()
                }
            }
        }
    }
    
    /// Confirmation pattern for important actions
    func confirm() {
        DispatchQueue.main.async {
            self.mediumImpact()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.lightImpact()
            }
        }
    }
    
    /// Attention pattern for alerts
    func attention() {
        DispatchQueue.main.async {
            self.warning()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.lightImpact()
            }
        }
    }
}

// MARK: - View Extension for Easy Access

import SwiftUI

extension View {
    /// Add haptic feedback to button taps
    func hapticFeedback(_ style: HapticStyle = .light) -> some View {
        self.onTapGesture {
            switch style {
            case .light:
                HapticManager.shared.lightImpact()
            case .medium:
                HapticManager.shared.mediumImpact()
            case .heavy:
                HapticManager.shared.heavyImpact()
            case .success:
                HapticManager.shared.success()
            case .warning:
                HapticManager.shared.warning()
            case .error:
                HapticManager.shared.error()
            case .selection:
                HapticManager.shared.selectionChanged()
            case .celebrate:
                HapticManager.shared.celebrate()
            case .confirm:
                HapticManager.shared.confirm()
            case .attention:
                HapticManager.shared.attention()
            }
        }
    }
}

enum HapticStyle {
    case light, medium, heavy
    case success, warning, error
    case selection
    case celebrate, confirm, attention
}
