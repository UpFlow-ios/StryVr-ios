//
//  TabItem.swift
//  StryVr
//
//  Created by Joe Dormond on 4/28/25.
//
//  📂 Enum - Defines available tabs for the CustomTabBar.
//

import SwiftUI

enum TabItem: Int, CaseIterable {
    case home, feed, profile, reports

    var title: String {
        switch self {
        case .home: return "Home"
        case .feed: return "Feed"
        case .profile: return "Profile"
        case .reports: return "Reports"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .feed: return "list.bullet"
        case .profile: return "person.fill"
        case .reports: return "chart.bar.fill"
        }
    }

    var systemIcon: String {
        return icon  // Use the same SF Symbol names
    }

    var colorCode: String {
        switch self {
        case .home: return "blue"
        case .feed: return "orange"
        case .profile: return "purple"
        case .reports: return "green"
        }
    }

    static var mock: TabItem {
        .home
    }
}
