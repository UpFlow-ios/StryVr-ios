//
//  Skill.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct Skill: Identifiable, Codable {
    let id: String
    let name: String
    let proficiencyLevel: Double  // from 0.0 to 1.0
    let lastPracticed: Date?
}
