//
//  AISuggestionResponse.swift
//  StryVr
//
//  Created by Joe Dormond on 5/29/25.
//
//  🤖 Model for AI-generated skill suggestions
//

import Foundation

struct AISuggestionResponse: Decodable {
    let generated_text: String

    func generatedSkills() -> [String] {
        generated_text
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
