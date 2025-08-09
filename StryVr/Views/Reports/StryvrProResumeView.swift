import OSLog
//
//  StryvrProResumeView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/30/25.
//
import PDFKit
import StoreKit
import SwiftUI

struct StryvrProResumeView: View {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.stryvr.app",
        category: "StryvrProResumeView"
    )

    @State private var isPurchased = false
    @State private var isGenerating = false
    @State private var resumeURL: URL?

    var body: some View {
        VStack(spacing: 20) {
            Text("Download Your Verified Résumé")
                .font(.title2.bold())

            Text("Includes verified work history, employer feedback, and skills.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            if isGenerating {
                ProgressView("Generating Résumé...")
            } else {
                Button(
                    action: {
                        handlePurchase()
                    },
                    label: {
                        Text(isPurchased ? "Download Résumé" : "Buy for $2.00")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                )
                .padding(.horizontal)
            }

            if let url = resumeURL {
                ShareLink(item: url) {
                    Label("Open Résumé", systemImage: "doc.text")
                }
                .padding(.top, 12)
            }
        }
        .padding()
        .onAppear {
            blockScreenCapture()
        }
    }

    private func handlePurchase() {
        if isPurchased {
            generatePDF()
        } else {
            Task {
                do {
                    // TODO: Implement StoreKit 2 purchase flow
                    // For now, simulate successful purchase
                    isPurchased = true
                    generatePDF()
                } catch {
                    logger.error("Purchase failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func generatePDF() {
        isGenerating = true
        let mockResumeData = ResumeData(
            name: "Professional User",
            location: "StryVr Platform",
            companies: ["Tech Company A", "Startup B", "Enterprise C"],
            skills: [("Swift", 95), ("Leadership", 90), ("Analytics", 85)],
            workImpact: "Increased team productivity by 40%",
            teamFeedback: "Exceptional performer and mentor"
        )
        let pdfURL = ResumePDFGenerator.shared.createPDF(resumeData: mockResumeData)
        resumeURL = pdfURL
        isGenerating = false
    }

    private func blockScreenCapture() {
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main
        ) { _ in
            Task { @MainActor in
                if UIScreen.main.isCaptured {
                    // Trigger security response if screen is being recorded
                    // You can also display a blur overlay here
                    logger.warning("Screen recording detected!")
                }
            }
        }
    }
}
