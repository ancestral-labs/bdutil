//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import PhaseKit

class UnixProcess: Process {
    
    let image: String
    let dev: String
    
    init(image: String, dev: String) {
        self.image = image
        self.dev = dev
    }
    
    
    func burn() async {
        // ---------------UNIX-------------------
        
        // TODO NEXT Start progress bar with Progress.swift
        // TODO Convert ISO to IMG
        // TODO Burn IMG (dd)
        // TODO Toggle flag to legacy partition
        // TODO Finish progress bar with TerminalUI
        // TODO Print success
            
        print(Constants.startMessageUNIX)
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForUNIX(deviceURL: URL(filePath: self.dev)) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: {
                        try Engine.copyToDevForUNIX(
                            isoURL: URL(filePath: self.image),
                            devURL: URL(filePath: self.dev)
                        )
                    }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: self.dev)) }
                ),
                Action(message: Constants.statusSuccess)
            ]
        ).runAll()
    }
}
