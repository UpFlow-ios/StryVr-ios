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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI.git", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(url: "https://github.com/DaveWoodCom/XCGLogger", from: "7.0.1"),
    ],
    targets: [
        .target(
            name: "StryVrModule",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "ConfettiSwiftUI", package: "ConfettiSwiftUI"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "XCGLogger", package: "XCGLogger"),
            ],
            path: "StryVrModule"
        ),
        .executableTarget(
            name: "stryvr-app",
            dependencies: ["StryVrModule"],
            path: "Sources/stryvr-app"
        ),
    ]
)
