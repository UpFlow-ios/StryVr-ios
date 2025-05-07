//
//  EmployeeTimelineEvent.swift
//  StryVr
//
//  Created by Joe Dormond on 5/6/25.
//

import Foundation

struct EmployeeTimelineEvent: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let timestamp: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}


