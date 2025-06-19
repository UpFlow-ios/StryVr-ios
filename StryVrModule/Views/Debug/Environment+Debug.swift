//  Environment+Debug.swift
//  StryVr

import Foundation
import SwiftUI

extension EnvironmentValues {
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

