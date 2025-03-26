//
//  SkillProgress.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct SkillProgress: Identifiable, Codable {
    let id: String
    let skillName: String
    let progressPercentage: Double  // from 0.0 to 100.0
    let lastUpdated: Date
}
