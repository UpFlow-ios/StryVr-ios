//
//  ChallengeModel.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct ChallengeModel: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
    let participants: [String]
    let isActive: Bool
}
