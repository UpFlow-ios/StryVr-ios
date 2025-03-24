// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StryVr",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "StryVr", targets: ["StryVr"]),
    ],
    dependencies: [
        // External packages if you have any (add here)
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
    ],
    targets: [
        .target(
            name: "StryVr",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            path: "StryVr"
        ),
        .testTarget(
            name: "StryVrTests",
            dependencies: ["StryVr"]
        ),
    ]
)
