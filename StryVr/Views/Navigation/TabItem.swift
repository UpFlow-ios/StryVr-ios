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
    case home, connect, community, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .connect: return "Connect"
        case .community: return "Community"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "icon_home"
        case .connect: return "video.badge.plus"
        case .community: return "icon_community"
        case .profile: return "icon_profile"
        }
    }
}
