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

        let lottieView = LottieAnimationView(animation: animation)
        lottieView.contentMode = UIView.ContentMode.scaleAspectFit
        lottieView.loopMode = loopMode
        lottieView.animationSpeed = speed

        // Add to view hierarchy
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieView)

        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: view.topAnchor),
            lottieView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lottieView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Store reference for later use
        context.coordinator.animationView = lottieView

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
            animationView?.pause()
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
