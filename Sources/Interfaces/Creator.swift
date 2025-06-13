//
//  Burner.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser

struct Creator: AsyncParsableCommand {
    
    static let configuration = InfoMap.loadCommandConfigurationKeys(
        cli: .Creator,
        conf: CommandConfiguration(
            commandName: "Name",
            abstract: "Abstract"
        )
    )
    
    @Argument(help: "Operating system installation type: dos, unix or macos")
    var osType: OSTypes
    
    @Argument(help: "Disc image or app file path")
    var image: String

    @Argument(help: "Disk path")
    var dev: String
    
    func run() async {
        
        await Create.run(osType: osType, image: image, dev: dev)

    }
}

public enum OSTypes: String, ExpressibleByArgument {
    case dos = "dos"
    case unix = "unix"
    case macos = "macos"
}
