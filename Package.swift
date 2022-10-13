// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdyenAuthentication",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AdyenAuthentication",
            targets: ["AdyenAuthentication"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "AdyenAuthentication",
            path: "XCFramework/Dynamic/AdyenAuthentication.xcframework")
    ]
)
