//
//  Command.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 26/11/23.
//

import ArgumentParser

@main
struct Main: AsyncParsableCommand {
    
    static let configuration = InfoMap.loadCommandConfigurationKeys(
        cli: .Main,
        conf: CommandConfiguration(
            commandName: "Name",
            abstract: "Abstract",
            version: "Version",
            subcommands: [Creator.self],
            defaultSubcommand: Creator.self
        )
    )
}
