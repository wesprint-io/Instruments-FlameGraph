// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlameGraph",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "FlameGraph", targets: ["FlameGraph"]),
        .library(name: "FlameGraphCore", targets: ["FlameGraphCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "FlameGraph",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "FlameGraphCore",
            ]
        ),
        .target(
            name: "FlameGraphCore",
            dependencies: []
        ),
        .testTarget(
            name: "FlameGraphTests",
            dependencies: ["FlameGraph"]
        ),
        .testTarget(
            name: "FlameGraphCoreTests",
            dependencies: ["FlameGraphCore"]
        ),
    ]
)
