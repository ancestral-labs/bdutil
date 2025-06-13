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
        commandName: InfoMap.shared.getValueMain(forKey: "Name") ?? "phaseclt",
        abstract: InfoMap.shared.getValueMain(forKey: "Abstract") ?? "PhaseCLT",
        version: InfoMap.shared.getValueMain(forKey: "Version") ?? "0.0.0",
        subcommands: [Creator.self],
        defaultSubcommand: Creator.self
    )
}
