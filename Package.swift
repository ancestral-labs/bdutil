// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhaseCLT",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/orchetect/PListKit", from: "2.0.3"),
        .package(
            url: "https://github.com/AncestralLabs/PhaseKit.git",
            branch: "develop"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PhaseCLT",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PListKit", package: "plistkit"),
                .product(name: "PhaseKit", package: "phasekit")
            ],
            resources: [
                .process("Config.plist")
            ]
        ),
    ]
)
