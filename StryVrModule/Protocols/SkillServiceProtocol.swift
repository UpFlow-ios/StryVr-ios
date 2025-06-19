//
//  SkillServiceProtocol.swift
//  StryVr
//
//  Created by Joe Dormond on 6/5/25.
//  🔌 Skill Service Protocol – Abstracted interface for skill-related backend services
//

import Foundation

/// Protocol defining skill-related service operations used in StryVr
protocol SkillServiceProtocol {
    
    /// Fetches all skills for the given user
    func fetchSkills(for userID: String, completion: @escaping (Result<[SkillMatrixEntry], Error>) -> Void)
    
    /// Updates the rating of a specific skill
    func updateSkillRating(
        userID: String,
        skillID: String,
        newRating: Double,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    /// Adds a new skill entry for a user
    func addSkill(
        userID: String,
        skill: SkillMatrixEntry,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    /// Deletes a skill from a user's skill matrix
    func deleteSkill(
        userID: String,
        skillID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}


