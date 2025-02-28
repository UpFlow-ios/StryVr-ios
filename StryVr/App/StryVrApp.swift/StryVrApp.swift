import SwiftUI
import CocoaLumberjackSwift

@main
struct StryVrApp: App {
    init() {
        DDLog.add(DDOSLogger.sharedInstance) // Enable logging
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

