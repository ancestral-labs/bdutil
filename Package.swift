// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Copyright 2023-2026 Ancestral Labs
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
        .package(url: "https://github.com/ancestral-labs/BootDriveKit.git", from: "0.1.2")
        // .package(path: "~/XcodeProjects/BootDriveKit")
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
