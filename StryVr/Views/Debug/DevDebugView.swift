//
//  DevDebugView.swift
//  StryVr
//
//  🧪 Developer Tools: Pulse, Logs, Crash Sim, Deep Link Tester
//

import SwiftUI
import Pulse
import PulseUI
import XCGLogger
import FirebaseAuth
import DeepLinkKit

struct DevDebugView: View {
    @State private var showLogs = false
    @State private var showAuthStatus = false
    @State private var testDeepLink = ""
    @State private var logMessage = ""
    @State private var enableMockMode = false

    private let logger = XCGLogger.default

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("🪵 Logs & Network")) {
                    Toggle("Show Pulse Logs", isOn: $showLogs)
                        .onChange(of: showLogs) { newValue in
                            if newValue {
                                logger.info("🪵 Pulse logs enabled")
                            }
                        }

                    TextField("Log message", text: $logMessage)
                    Button("Log Custom Info") {
                        logger.info("Custom Log: \(logMessage)")
                        logMessage = ""
                    }
                }

                Section(header: Text("🔐 Auth & User")) {
                    Button("Check Auth State") {
                        showAuthStatus = true
                        logger.debug("User is logged in: \(Auth.auth().currentUser != nil)")
                    }

                    Button("Force Logout") {
                        try? Auth.auth().signOut()
                        logger.warning("User manually logged out from debug panel")
                    }
                }

                Section(header: Text("🔗 Deep Link Tester")) {
                    TextField("stryvr://deeplink?route=home", text: $testDeepLink)
                    Button("Trigger Deep Link") {
                        if let url = URL(string: testDeepLink) {
                            _ = DPLDeepLinkRouter().handle(url)
                            logger.info("Triggered deep link: \(url.absoluteString)")
                        }
                    }
                }

                Section(header: Text("🧪 Simulations")) {
                    Toggle("Enable Mock Mode", isOn: $enableMockMode)
                        .onChange(of: enableMockMode) { val in
                            logger.info("Mock mode toggled: \(val)")
                        }

                    Button("Simulate Crash") {
                        logger.error("💥 Simulated crash initiated")
                        fatalError("🧨 Simulated crash for testing")
                    }
                }

                Section {
                    Button("Dismiss Debug Panel") {
                        showLogs = false
                    }.foregroundColor(.red)
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
