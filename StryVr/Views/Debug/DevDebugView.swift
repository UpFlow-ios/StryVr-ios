//
//  DevDebugView.swift
//  StryVr
//
//  🧪 Developer Debug Panel – Logs, Feature Flags, Crash Sim, Deep Links
//

import SwiftUI
import Pulse
import PulseUI
import XCGLogger
import FirebaseAuth
import DeepLinkKit

struct DevDebugView: View {
    @State private var showLogs = false
    @State private var logMessage = ""
    @State private var testDeepLink = ""
    @State private var showAuthStatus = false

    @Environment(\.isDebug) var isDebug
    private let logger = XCGLogger.default

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Logs
                if isDebug {
                    Section(header: Text("🪵 Logs & Console")) {
                        Toggle("Show Pulse Logs", isOn: $showLogs)

                        TextField("Enter log message", text: $logMessage)
                        Button("Log Info Message") {
                            logger.info("💬 \(logMessage)")
                            logMessage = ""
                        }
                    }
                }

                // MARK: - Firebase Auth
                Section(header: Text("🔐 Firebase Auth")) {
                    Button("Check Auth State") {
                        logger.debug("User is signed in: \(Auth.auth().currentUser != nil)")
                        showAuthStatus = true
                    }

                    Button("Force Sign Out") {
                        try? Auth.auth().signOut()
                        logger.warning("User signed out manually from debug panel.")
                    }
                }

                // MARK: - Feature Flags
                Section(header: Text("🧪 Feature Flags")) {
                    Toggle("Enable Mock Data", isOn: Binding(
                        get: { FeatureFlags.enableMockData },
                        set: { FeatureFlags.enableMockData = $0 }
                    ))

                    Toggle("Enable Confetti", isOn: Binding(
                        get: { FeatureFlags.enableConfetti },
                        set: { FeatureFlags.enableConfetti = $0 }
                    ))

                    Toggle("Enable Deep Linking", isOn: Binding(
                        get: { FeatureFlags.enableDeepLinks },
                        set: { FeatureFlags.enableDeepLinks = $0 }
                    ))
                }

                // MARK: - Deep Link Tester
                if FeatureFlags.enableDeepLinks {
                    Section(header: Text("🔗 Deep Link Tester")) {
                        TextField("stryvr://deeplink?route=home", text: $testDeepLink)

                        Button("Trigger Deep Link") {
                            if let url = URL(string: testDeepLink) {
                                _ = DPLDeepLinkRouter().handle(url)
                                logger.info("Deep link triggered: \(url.absoluteString)")
                            }
                        }
                    }
                }

                // MARK: - Crash Sim
                Section(header: Text("💥 Crash & Reset")) {
                    Button("Simulate Crash") {
                        logger.error("💣 Simulated crash triggered from DevDebugView")
                        fatalError("💥 Simulated crash")
                    }

                    Button("Clear Logs") {
                        logger.info("🧹 Logs cleared (manual trigger)")
                    }
                }
            }
            .sheet(isPresented: $showLogs) {
                NavigationView {
                    ConsoleView()
                }
            }
            .navigationTitle("🔧 Dev Debug Panel")
        }
    }
}
