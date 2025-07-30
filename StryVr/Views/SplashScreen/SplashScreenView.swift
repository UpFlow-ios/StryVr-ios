//
//  SplashScreenView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/17/25.
//

import AVKit
import OSLog
import SwiftUI

/// Animated splash screen using a short `.mp4` intro video with dark/light mode support
struct SplashScreenView: View {
    @State private var isFinished = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "StryVr", category: "SplashScreenView")

    var body: some View {
        Group {
            if isFinished {
                // Show main app content based on authentication state
                if authViewModel.isAuthenticated {
                    HomeView()
                } else {
                    LoginView()
                }
            } else {
                SplashVideoPlayer(videoName: "stryvr2", videoExtension: "mp4") {
                    logger.info("🎬 Splash video finished")
                    isFinished = true
                }
                .ignoresSafeArea()
                .background(backgroundColor)
            }
        }
    }

    // MARK: - Dynamic Background Color

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
}

// MARK: - Video Player Component

struct SplashVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoExtension: String
    let onFinished: () -> Void

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false

        if let url = Bundle.main.url(forResource: videoName, withExtension: videoExtension) {
            let player = AVPlayer(url: url)
            controller.player = player

            // Auto-detect when video finishes
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                onFinished()
            }

            player.play()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


