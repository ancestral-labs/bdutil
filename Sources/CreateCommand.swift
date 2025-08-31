//
//  Burner.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser
import PhaseKit


public enum OSTypes: String {
    case dos = "dos"
    case unix = "unix"
    case macos = "macos"
}

struct CommonParameters: ParsableArguments {
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpImg))
    var image: String

    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpDev))
    var dev: String
}

extension Application {
    struct CreateCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.creator[.name],
            abstract: PMap.creator[.description],
            subcommands: [DOSCommand.self, UnixCommand.self, MacOSCommand.self]
        )
    }
    
    // Definition
    
    struct DOSCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.dos[.name],
            abstract: PMap.dos[.description]
        )
        
        @OptionGroup()
        var common: CommonParameters
        
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpScheme))
        var scheme: SchemeArg = .gpt
        
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpFileSystem))
        var fileSystem: FileSystemArg = .fat32
        
        func run() async {
            
            await Create.run(osType: .dos, image: common.image, dev: common.dev, scheme: scheme, fileSystem: fileSystem)
        }
    }
    
    struct UnixCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.unix[.name],
            abstract: PMap.unix[.description]
        )
        
        @OptionGroup()
        var common: CommonParameters
        
        func run() async {
            
            await Create.run(osType: .unix, image: common.image, dev: common.dev)
        }
    }
    
    struct MacOSCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.macos[.name],
            abstract: PMap.macos[.description]
        )
        
        @OptionGroup()
        var common: CommonParameters
        
        func run() async {
            
            await Create.run(osType: .macos, image: common.image, dev: common.dev)
        }
    }
}
