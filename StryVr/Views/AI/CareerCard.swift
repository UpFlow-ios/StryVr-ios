//
//  CareerCard.swift
//  StryVr
//
//  Created by Joe Dormond on 4/1/25.
//

import SwiftUI

/// Represents a clean, reusable career suggestion card from AI
struct CareerCard: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Main Career Title
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
                .accessibilityLabel("Career title: \(title)")

            // Description or hint
            Text("AI suggested this role based on your skill progress.")
                .font(.caption)
                .foregroundColor(.secondary)
                .accessibilityLabel("AI suggested this role based on your skill progress.")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}
