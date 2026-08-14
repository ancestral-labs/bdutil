//
//  Application.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 26/11/23.
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
