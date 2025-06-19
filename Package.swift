// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "stryvr-ios",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .executable(
            name: "stryvr-app",
            targets: ["stryvr-app"]
        )
    ],
    dependencies: [],
    targets: [
        // ✅ All your core logic (views, models, etc.)
        .target(
            name: "StryVrModule",
            path: "StryVrModule"
        ),

        // ✅ App launcher
        .executableTarget(
            name: "stryvr-app",
            dependencies: ["StryVrModule"],
            path: "Sources/stryvr-app"
        )
    ]
)
