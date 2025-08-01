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
    @MainActor static let shared = AIGreetingManager()

    @Published var currentGreeting: String = ""
    @Published var personalizedGoal: String = ""
    @Published var motivationTip: String = ""
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
            self.generatePersonalizedGoal()
            self.generateMotivationTip()
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
            "🏆 Every step forward is progress!",
            "✨ Your future self is thanking you!",
            "🎨 Creativity flows through you!",
            "🚀 Time to level up your skills!"
        ]

        let timeBasedGreetings = [
            "Good morning! ☀️",
            "Good afternoon! 🌤️",
            "Good evening! 🌙"
        ]

        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting

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
    
    func updateContext(userAction: String) {
        // Update context based on user action
        switch userAction {
        case "goal_completed":
            motivationTip = "🎉 Amazing! You're building momentum!"
        case "badge_unlocked":
            motivationTip = "🏆 You're on fire! Keep pushing forward!"
        default:
            motivationTip = "💪 Every action brings you closer to your goals!"
        }
        
        // Regenerate personalized goal
        generatePersonalizedGoal()
    }
    
    private func generatePersonalizedGoal() {
        let goals = [
            "🎯 Complete 3 skill assessments today",
            "📚 Spend 30 minutes on learning modules",
            "🤝 Engage with 2 team challenges",
            "📊 Review your progress dashboard",
            "🎨 Explore new skill categories"
        ]
        
        personalizedGoal = goals.randomElement() ?? goals[0]
    }
    
    private func generateMotivationTip() {
        let tips = [
            "💡 Remember: Progress over perfection!",
            "🌟 Small steps lead to big changes!",
            "🔥 Consistency is the key to success!",
            "🎯 Focus on what you can control!",
            "✨ Your future self is watching!",
            "🚀 Every expert was once a beginner!",
            "💪 Challenges make you stronger!",
            "🎨 Innovation happens outside your comfort zone!"
        ]
        
        motivationTip = tips.randomElement() ?? tips[0]
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
