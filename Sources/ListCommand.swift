//
//  ListCommand.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 06/07/2026.
//

import ArgumentParser
import BootDriveKit

extension Application {

    /// The `list` subcommand, which enumerates available external drives.
    struct ListCommand: AsyncParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: PMap.lister[.name],
            abstract: PMap.lister[.description]
        )

        /// Runs the drive-listing command.
        func run() {

            List.run()
        }
    }
}
