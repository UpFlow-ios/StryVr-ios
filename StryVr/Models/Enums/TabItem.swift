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
        case .home: return "icon_home"
        case .feed: return "icon_feed"
        case .profile: return "icon_profile"
        case .reports: return "icon_reports"
        }
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
