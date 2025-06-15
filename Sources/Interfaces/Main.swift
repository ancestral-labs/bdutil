//
//  Command.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 26/11/23.
//

import ArgumentParser

@main
struct Main: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: PMap.main["Name"] ?? "phaseclt",
        abstract: PMap.main["Abstract"] ?? "PhaseCLT",
        version: PMap.main["Version"] ?? "0.0.0",
        subcommands: [Creator.self],
        defaultSubcommand: Creator.self
    )
}
