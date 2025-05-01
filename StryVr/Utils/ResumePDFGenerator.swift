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

    func createPDF() -> URL {
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

            let resumeText = """
            Name: Matthew Anderson
            Location: 1234 Elm St, Springfield, IL 62701

            — Verified Companies —
            • Microsoft – Software Engineer (May 2021 – April 2024)
            • Google – Web Developer (Jan 2018 – April 2021)
            • Meta – IT Specialist (Aug 2016 – Jan 2018)
            • Creative Agency – Graphic Designer (2013–2015)

            — Top Skills —
            • Swift – 62%
            • UI Design – 25%
            • Firebase – 13%

            — Work Impact —
            Built scalable app features used by millions

            — Team Feedback —
            Strong collaborator and communicates effectively
            """

            resumeText.draw(in: CGRect(x: 36, y: 50, width: pageWidth - 72, height: pageHeight - 100), withAttributes: attributes)
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Verified_Resume_Stryvr.pdf")
        try? data.write(to: url)
        return url
    }
}
