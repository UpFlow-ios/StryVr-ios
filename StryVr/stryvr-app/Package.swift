// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "stryvr-app",
    platforms: [
        .visionOS(.v1),
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "stryvr-app",
            targets: ["stryvr-app"]
        ),
    ],
    dependencies: [
        // Add your future dependencies here
    ],
    targets: [
        .executableTarget(
            name: "stryvr-app",
            path: "Sources/stryvr-app"
        )
    ]
)
