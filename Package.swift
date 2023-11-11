// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/takaakimiyoshi/swift-architecture-template-utility",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: [
                .product(name: "Utility", package: "swift-architecture-template-utility"),
            ]
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"]
        ),
    ]
)
