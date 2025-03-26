//
//  Mentor.swift
//  StryVr
//
//  Created by Joe Dormond on 3/26/25.
//

import Foundation

struct Mentor: Identifiable, Codable {
    let id: String
    let name: String
    let bio: String
    let skills: [String]
    let rating: Double
    let reviewsCount: Int
    let profileImageURL: String?
}
