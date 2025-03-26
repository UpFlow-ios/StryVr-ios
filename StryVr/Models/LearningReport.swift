//
//  LearningReport.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct LearningReport: Identifiable, Codable {
    let id: String
    let userId: String
    let generatedOn: Date
    let skillImprovements: [SkillProgress]
    let summary: String
}
