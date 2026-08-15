//
//  Application.swift
//  bdutil
//
//  Copyright 2023-2026 Ancestral Labs
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import ArgumentParser

/// The entry point of the `bdutil` command-line tool.
///
/// `bdutil` is a bootable media creation utility for Apple silicon Macs.
/// This type defines the root command and registers its subcommands using
/// [swift-argument-parser](https://github.com/apple/swift-argument-parser).
@main
struct Application: AsyncParsableCommand {

    /// The root command configuration.
    ///
    /// Command metadata (name, abstract, and version) is loaded from the
    /// bundled `Properties.plist` resource through `PMap`.
    static let configuration = CommandConfiguration(
        commandName: PMap.main[.name],
        abstract: PMap.main[.description],
        version: PMap.main[.version],
        subcommands: [
            CreateCommand.self,
            ListCommand.self
        ],
        defaultSubcommand: CreateCommand.self
    )
}
