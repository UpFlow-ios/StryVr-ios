//
//  StryvrProResumeView.swift
//  StryVr
//
//  Created by Joe Dormond on 4/30/25.
//
import SwiftUI
import StoreKit
import PDFKit

struct StryvrProResumeView: View {
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
                Button(action: {
                    handlePurchase()
                }) {
                    Text(isPurchased ? "Download Résumé" : "Buy for $2.00")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
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
                    let result = try await AppStore.purchase("stryvr.resume.verified")
                    if case .success = result {
                        isPurchased = true
                        generatePDF()
                    }
                } catch {
                    print("Purchase failed: \(error)")
                }
            }
        }
    }

    private func generatePDF() {
        isGenerating = true
        let pdfURL = ResumePDFGenerator.shared.createPDF()
        resumeURL = pdfURL
        isGenerating = false
    }

    private func blockScreenCapture() {
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { _ in
            if UIScreen.main.isCaptured {
                // Trigger security response if screen is being recorded
                // You can also display a blur overlay here
                print("Screen recording detected!")
            }
        }
    }
}
