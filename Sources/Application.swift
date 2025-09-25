//
//  Command.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 26/11/23.
//

import ArgumentParser

@main
struct Application: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: PMap.main[.name],
        abstract: PMap.main[.description],
        version: PMap.main[.version],
        subcommands: [CreateCommand.self],
        defaultSubcommand: CreateCommand.self
    )
}
