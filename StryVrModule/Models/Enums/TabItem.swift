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
    case home, learning, community, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .learning: return "Learn"
        case .community: return "Community"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "icon_home"
        case .learning: return "icon_learning"
        case .community: return "icon_community"
        case .profile: return "icon_profile"
        }
    }

    var colorCode: String {
        switch self {
        case .home: return "blue"
        case .learning: return "orange"
        case .community: return "green"
        case .profile: return "purple"
        }
    }

    static var mock: TabItem {
        .home
    }
}
