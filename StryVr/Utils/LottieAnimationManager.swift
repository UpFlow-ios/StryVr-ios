//
//  LottieAnimationManager.swift
//  StryVr
//
//  Created for StryVr iOS app.
//  Provides SwiftUI wrapper for Lottie animations.
//

import Lottie
import OSLog
import SwiftUI

/// SwiftUI wrapper for Lottie animations
struct LottieAnimationView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let speed: CGFloat

    init(
        animationName: String,
        loopMode: LottieLoopMode = .playOnce,
        speed: CGFloat = 1.0
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.speed = speed
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        // Load animation from bundle
        guard let animation = LottieAnimation.named(animationName) else {
            logger.error("❌ Failed to load Lottie animation: \(animationName)")
            return view
        }

        let animationView = LottieAnimationView()
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed

        // Add to view hierarchy
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Store reference for later use
        context.coordinator.animationView = animationView

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update animation if needed
        context.coordinator.animationView?.play()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var animationView: LottieAnimationView?

        deinit {
            animationView?.stop()
        }
    }
}

// MARK: - Logger
private let logger = Logger(subsystem: "com.stryvr.app", category: "LottieAnimationManager")

// MARK: - Preview
#Preview {
    LottieAnimationView(animationName: "confetti", loopMode: .playOnce)
        .frame(width: 200, height: 200)
}
