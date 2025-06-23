//
//  ResumePDFGenerator.swift
//  StryVr
//
//  Created by Joe Dormond on 4/30/25.
//

import Foundation
import PDFKit
import UIKit

class ResumePDFGenerator {
    static let shared = ResumePDFGenerator()

    /// Generates a PDF resume with the given details.
    /// - Parameters:
    ///   - name: The name of the individual.
    ///   - location: The location/address of the individual.
    ///   - companies: An array of verified companies with role and dates.
    ///   - skills: An array of tuples containing skill name and proficiency percentage.
    ///   - workImpact: A description of the work impact.
    ///   - teamFeedback: Feedback from the team.
    /// - Returns: A URL pointing to the generated PDF file.
    func createPDF(
        name: String,
        location: String,
        companies: [String],
        skills: [(name: String, percentage: Int)],
        workImpact: String,
        teamFeedback: String
    ) -> URL {
        let pdfMetaData = [
            kCGPDFContextCreator: "Stryvr",
            kCGPDFContextAuthor: "Stryvr AI Engine",
            kCGPDFContextTitle: "Verified Résumé"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { context in
            context.beginPage()
            let context = context.cgContext

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: paragraphStyle
            ]

            let companiesText = companies.map { "• \($0)" }.joined(separator: "\n")
            let skillsText = skills.map { "• \($0.name) – \($0.percentage)%" }.joined(separator: "\n")

            let resumeText = """
            Name: \(name)
            Location: \(location)

            — Verified Companies —
            \(companiesText)

            — Top Skills —
            \(skillsText)

            — Work Impact —
            \(workImpact)

            — Team Feedback —
            \(teamFeedback)
            """

            resumeText.draw(in: CGRect(x: 36, y: 50, width: pageWidth - 72, height: pageHeight - 100), withAttributes: attributes)
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Verified_Resume_Stryvr.pdf")
        try? data.write(to: url)
        return url
    }
}
