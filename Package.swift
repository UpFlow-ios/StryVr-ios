// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "stryvr-ios",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .executable(
            name: "stryvr-app",
            targets: ["stryvr-app"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "StryVrModule",
            path: "StryVrModule"
        ),
        .executableTarget(
            name: "stryvr-app",
            dependencies: ["StryVrModule"],
            path: "Sources/stryvr-app"
        ),
    ]
)
