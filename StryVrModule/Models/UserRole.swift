//
//  UserRole.swift
//  StryVr
//
//  Created by Joe Dormond on 4/14/25.
//

import Foundation

/// Defines user roles within StryVr
enum UserRole: String, Codable {
    /// Represents an admin user (future enterprise/management use)
    case admin = "Admin"

    /// Provides a default user role
    static var defaultRole: UserRole {
        return .admin
    }

    /// Validates if a given string matches a valid role
    static func isValidRole(_ role: String) -> Bool {
        return UserRole(rawValue: role) != nil
    }
}
