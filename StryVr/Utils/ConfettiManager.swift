//
//  ConfettiManager.swift
//  StryVr
//
//  Created by Joe Dormond on 5/5/25.
//  🎉 Central Confetti Manager for Achievements, Streaks & Challenges
//

import SwiftUI
import ConfettiSwiftUI

/// Singleton manager to trigger confetti from anywhere in the app
final class ConfettiManager: ObservableObject {
    static let shared = ConfettiManager()

    /// Counter that drives the confetti animation
    @Published var counter: Int = 0

    private init() {}

    /// Call this to launch a confetti burst
    func triggerConfetti() {
        DispatchQueue.main.async {
            self.counter += 1
        }
    }
}

