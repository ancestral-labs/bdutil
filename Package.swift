// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bclt",
    platforms: [.macOS(.v15)],
    products: [
        .executable(
            name: "bclt",
            targets: ["bclt"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        // .package(url: "https://github.com/jkandzi/Progress.swift.git", from: "0.4.0"),
        .package(url: "https://github.com/dominicegginton/spinner.git", from: "2.1.0"),
        .package(url: "https://github.com/orchetect/PListKit", from: "2.0.3"),
        // .package(url: "https://github.com/AncestralLabs/BootKit.git", branch: "main")
        .package(path: "/Users/ant04x/XcodeProjects/BootKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "bclt",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Spinner", package: "spinner"),
                .product(name: "PListKit", package: "plistkit"),
                .product(name: "BootKit", package: "bootkit")
            ],
            resources: [
                .process("Properties.plist")
            ]
        ),
    ]
)
