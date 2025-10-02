//
//  Burner.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser
import BootKit


public enum OSTypes: String {
    case dos = "dos"
    case unix = "unix"
    case macos = "macos"
}

struct StandarParameters: ParsableArguments {
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpImg))
    var image: String
}

struct DarwinParameters: ParsableArguments {
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpApp))
    var app: String
}

struct CommonParameters: ParsableArguments {

    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpDev))
    var dev: String
    
    @Flag(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argQuiet))
    var quiet: Bool = false
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
        var standar: StandarParameters
        
        @OptionGroup()
        var common: CommonParameters
        
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpScheme))
        var scheme: SchemeArg = .gpt
        
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpFileSystem))
        var fileSystem: FileSystemArg = .fat32
        
        func run() async {
            
            await Create.run(osType: .dos, installer: standar.image, dev: common.dev, scheme: scheme, fileSystem: fileSystem, quiet: common.quiet)
        }
    }
    
    struct UnixCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.unix[.name],
            abstract: PMap.unix[.description]
        )
        
        @OptionGroup()
        var standar: StandarParameters
        
        @OptionGroup()
        var common: CommonParameters
        
        func run() async {
            
            await Create.run(osType: .unix, installer: standar.image, dev: common.dev, quiet: common.quiet)
        }
    }
    
    struct MacOSCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.macos[.name],
            abstract: PMap.macos[.description]
        )
        
        @OptionGroup()
        var darwin: DarwinParameters
        
        @OptionGroup()
        var common: CommonParameters
        
        func run() async {
            
            await Create.run(osType: .macos, installer: darwin.app, dev: common.dev, quiet: common.quiet)
        }
    }
}
