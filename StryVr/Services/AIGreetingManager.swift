//
//  AIGreetingManager.swift
//  StryVr
//
//  Created for StryVr iOS app.
//  Manages AI-powered personalized greetings for users.
//

import Foundation
import SwiftUI

@MainActor
class AIGreetingManager: ObservableObject {
    static let shared = AIGreetingManager()

    @Published var currentGreeting: String = ""
    @Published var isLoading: Bool = false
    @Published var lastUpdated: Date = Date()

    private init() {
        generateGreeting()
    }

    func generateGreeting() {
        isLoading = true

        // Simulate AI processing time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentGreeting = self.generatePersonalizedGreeting()
            self.isLoading = false
            self.lastUpdated = Date()
        }
    }

    private func generatePersonalizedGreeting() -> String {
        let greetings = [
            "🚀 Ready to crush your goals today?",
            "💪 Your potential is limitless!",
            "🌟 Let's make today amazing!",
            "🎯 Focus on progress, not perfection!",
            "🔥 You're building something incredible!",
            "💡 Innovation starts with you!",
            "🏆 Every step forward is a victory!",
            "✨ Your future self is thanking you!",
            "🎨 Creativity flows through you!",
            "🚀 Time to level up your skills!",
        ]

        let timeBasedGreetings = [
            "Good morning! ☀️",
            "Good afternoon! 🌤️",
            "Good evening! 🌙",
        ]

        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String

        switch hour {
        case 5..<12:
            timeGreeting = timeBasedGreetings[0]
        case 12..<17:
            timeGreeting = timeBasedGreetings[1]
        default:
            timeGreeting = timeBasedGreetings[2]
        }

        let randomGreeting = greetings.randomElement() ?? greetings[0]
        return "\(timeGreeting) \(randomGreeting)"
    }

    func refreshGreeting() {
        generateGreeting()
    }
}

// MARK: - Preview Support
extension AIGreetingManager {
    static var preview: AIGreetingManager {
        let manager = AIGreetingManager()
        manager.currentGreeting = "🚀 Ready to crush your goals today?"
        manager.isLoading = false
        return manager
    }
}
