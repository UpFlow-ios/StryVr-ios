// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "StryVrPackages",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "StryVrPackages",
            targets: ["StryVrTarget"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0"),
        .package(url: "https://github.com/kean/Pulse", from: "2.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI", from: "1.0.0"),
        .package(url: "https://github.com/DaveWoodCom/XCGLogger", from: "7.0.1"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "1.1.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"), // 🔐 NEW
    ],
    targets: [
        .target(
            name: "StryVrTarget",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "PulseUI", package: "Pulse"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "ConfettiSwiftUI", package: "ConfettiSwiftUI"),
                .product(name: "XCGLogger", package: "XCGLogger"),
                .product(name: "Introspect", package: "SwiftUI-Introspect"),
                .product(name: "KeychainAccess", package: "KeychainAccess"), // 🔐 NEW
            ]
        ),
    ]
)
