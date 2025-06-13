//
//  Burner.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser

struct Creator: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: InfoMap.shared.getValueCreator(forKey: "Name") ?? "create",
        abstract: InfoMap.shared.getValueCreator(forKey: "Abstract") ?? "Burns the selected OS to the target media device"
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
