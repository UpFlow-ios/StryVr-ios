//
//  DevDebugView.swift
//  StryVr
//
//  🧪 Developer Debug Panel – Logs, Feature Flags, Crash Sim, Deep Links, API Tests
//

import FirebaseAuth
import Pulse
import PulseUI
import SwiftUI
import XCGLogger

struct DevDebugView: View {
    @State private var showLogs = false
    @State private var logMessage = ""
    @State private var testDeepLink = ""
    @State private var showAuthStatus = false
    @State private var aiSuggestions: [String] = []
    @State private var apiTestResult: String = ""

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

                // MARK: - AI Test Section

                Section(header: Text("🤖 AI Recommendations Test")) {
                    Button("Fetch AI Recommendations") {
                        AIRecommendationService.shared.fetchSkillRecommendations(for: "testUserId123") { suggestions in
                            DispatchQueue.main.async {
                                aiSuggestions = suggestions
                                logger.info("✅ AI Suggestions: \(suggestions.joined(separator: ", "))")
                            }
                        }
                    }
                    if !aiSuggestions.isEmpty {
                        Text("AI Suggestions: \(aiSuggestions.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - API Test Section

                Section(header: Text("🌐 APIService Test")) {
                    Button("Test External API") {
                        APIService.shared.fetchData(from: "https://jsonplaceholder.typicode.com/posts") { result in
                            DispatchQueue.main.async {
                                switch result {
                                case let .success(data):
                                    apiTestResult = "✅ Received \(data.count) bytes"
                                    logger.info(apiTestResult)
                                case let .failure(error):
                                    apiTestResult = "❌ API Error: \(error)"
                                    logger.error(apiTestResult)
                                }
                            }
                        }
                    }
                    if !apiTestResult.isEmpty {
                        Text(apiTestResult)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - Deep Link Test

                Section(header: Text("🔗 Deep Link Simulation")) {
                    TextField("Paste test link", text: $testDeepLink)
                        .textFieldStyle(.roundedBorder)

                    Button("Simulate Deep Link") {
                        handleDeepLink(testDeepLink)
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

    private func handleDeepLink(_ link: String) {
        guard let url = URL(string: link) else {
            logger.error("❌ Invalid deep link: \(link)")
            return
        }

        logger.info("📲 Simulating deep link: \(url.absoluteString)")

        if url.host == "debug" {
            logger.info("🛠️ Triggered debug path via deep link")
        } else {
            logger.warning("⚠️ No route matched for: \(url.absoluteString)")
        }
    }
}
