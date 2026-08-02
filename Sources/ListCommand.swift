//
//  ListCommand.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 06/07/2026.
//

import ArgumentParser
import BootDriveKit

extension Application {
    
    // Definition
    struct ListCommand: AsyncParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: PMap.lister[.name],
            abstract: PMap.lister[.description]
        )
        
        func run() {
            
            List.run()
        }
    }
}
