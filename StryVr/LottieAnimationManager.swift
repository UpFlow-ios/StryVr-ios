//
//  LottieAnimationManager.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI
import Lottie

struct LottieAnimationView: UIViewRepresentable {
    var animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        animationView.contentMode = .scaleAspectFit
        let animationView = AnimationView(name: animationName)
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        return view
    }

        ])
    func updateUIView(_ uiView: UIView, context: Context) {}
}
