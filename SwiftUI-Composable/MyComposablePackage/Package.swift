// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MyComposablePackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MyComposablePackage",
            targets: ["MyComposablePackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.50.0"),
    ],
    targets: [
        .target(
            name: "MyComposablePackage",
            dependencies: []),
        .testTarget(
            name: "MyComposablePackageTests",
            dependencies: ["MyComposablePackage"]),
    ]
)
