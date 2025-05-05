//
//  VideoCategory.swift
//  StryVr
//
//  Created by Joe Dormond on 4/15/25.
//

import Foundation

/// Type of video content posted
enum VideoCategory: String, Codable, CaseIterable {
    /// Tutorials for developing skills
    case skillTutorial = "Skill Tutorial"
    /// Insights from the industry
    case industryInsights = "Industry Insights"
    /// Stories of success
    case successStory = "Success Story"
    /// Showcase of projects
    case projectShowcase = "Project Showcase"
    /// Other types of video content
    case other = "Other"

    /// Returns a user-friendly description of the video category
    var description: String {
        switch self {
        case .skillTutorial: return "Tutorials for developing skills."
        case .industryInsights: return "Insights from the industry."
        case .successStory: return "Stories of success."
        case .projectShowcase: return "Showcase of projects."
        case .other: return "Other types of video content."
        }
    }

    /// Validates if a given string matches a valid video category
    static func isValidCategory(_ category: String) -> Bool {
        return VideoCategory(rawValue: category) != nil
    }
}
