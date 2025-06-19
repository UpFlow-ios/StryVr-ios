//
//  LottieAnimationManager.swift
//  StryVr
//
//  Created by Joe Dormond on 5/14/25.
//  🎞️ Lottie Wrapper – SwiftUI-Compatible View for Confetti & Animations
//
import SwiftUI
import Lottie

/// SwiftUI-compatible wrapper for displaying Lottie animations
struct LottieAnimationView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    var onComplete: (() -> Void)? = nil

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)

        guard let animation = Animation.named(animationName) else {
            assertionFailure("⚠️ Lottie animation not found: \(animationName)")
            return containerView
        }

        let animationView = AnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isAccessibilityElement = true
        animationView.accessibilityLabel = "Lottie animation: \(animationName)"

        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        // Auto-play animation
        animationView.play { finished in
            if finished {
                onComplete?()
            }
        }

        context.coordinator.animationView = animationView
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        animationView.play { finished in
            if finished {
                onComplete?()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var animationView: AnimationView?
    }
}
