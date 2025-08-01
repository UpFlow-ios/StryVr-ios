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
    let generatedText: String
    
    private enum CodingKeys: String, CodingKey {
        case generatedText = "generated_text"
    }

    func generatedSkills() -> [String] {
        generatedText
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
