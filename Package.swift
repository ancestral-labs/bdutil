// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The Swift Package Manager manifest for the `bdutil` executable.
///
/// Declares the macOS platform requirement, external dependencies, the
/// `bdutil` executable target, and its test target.
let package = Package(
    name: "bdutil",
    platforms: [.macOS(.v15)],
    products: [
        .executable(
            name: "bdutil",
            targets: ["bdutil"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/dominicegginton/spinner.git", from: "2.1.0"),
        .package(url: "https://github.com/ShawnBaek/Table", exact: "2.1.1"),
        .package(url: "https://github.com/orchetect/PListKit", from: "2.0.3"),
        .package(url: "https://github.com/ancestral-labs/BootDriveKit.git", branch: "main")
        // .package(path: "/Users/ant04x/XcodeProjects/BootDriveKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "bdutil",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Spinner", package: "spinner"),
                .product(name: "PListKit", package: "plistkit"),
                .product(name: "Table", package: "table"),
                .product(name: "BootDriveKit", package: "bootdrivekit")
            ],
            resources: [
                .process("Properties.plist")
            ]
        ),
        .testTarget(
            name: "bdutilTests",
            dependencies: ["bdutil"]
        ),
    ]
)
