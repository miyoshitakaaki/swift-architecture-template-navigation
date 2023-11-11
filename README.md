# Navigation

Mobile architecture framework inspired by [FlowController](https://github.com/onmyway133/blog/issues/106).

## Overview

this framework handle screen transition.

## Intoroduction

[Swift Package Manager](https://www.swift.org/package-manager/) is supported.

### Into Project

add package into `Package Dependencies`

### Into Package

```swift
let package = Package(
    name: "Sample",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Sample",
            targets: ["Sample"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/miyoshitakaaki/swift-architecture-template-navigation",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "Sample",
            dependencies: [
                .product(name: "Navigation", package: "swift-architecture-template-navigation"),
            ]
        ),
        .testTarget(
            name: "SampleTests",
            dependencies: ["Sample"]
        ),
    ]
)
```

### Usage

`import Navigation`

## Requirements

- Xcode 14.3.1 or later
- iOS 14 or later

## Documentation

- [Getting Started](https://miyoshitakaaki.github.io/swift-architecture-template-navigation/documentation/navigation/gettingstarted)
- [Usage of respondor chain](https://miyoshitakaaki.github.io/swift-architecture-template-navigation/documentation/navigation/respondorchainusage)

## Generate docs

`make` or `make create_doc`

## Code Format

`swiftformat .`

## Versioning

[Semantic Versioning](https://semver.org/)
