//
//  Burner.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser

public enum OSTypes: String, ExpressibleByArgument {
    case dos = "dos"
    case unix = "unix"
    case macos = "macos"
}

extension Application {
    struct CreateCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.creator[.name],
            abstract: PMap.creator[.description]
        )
        
        @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpOSType))
        var osType: OSTypes
        
        @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpImg))
        var image: String

        @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpDev))
        var dev: String
        
        func run() async {
            
            await Create.run(osType: osType, image: image, dev: dev)

        }
    }
}
