//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import PhaseKit
import Spinner

class DOSProcess: Process {
    
    func burn(image: String, dev: String) async {
        // ---------------WINDOWS-------------------
        
        // TODO Start progress bar with TerminalUI
        // TODO Check device and system free space
        // TODO Mount ISO
        // TODO Format device partition with FAT32
        // TODO Copy files from ISO excluding WIM
        // TODO Check install.wim
        // TODO Split WIM in 4000 limit
        // TODO Toggle flag to legacy partition
        // TODO Finish progress bar with TerminalUI
        // TODO Print success
        
        print(Constants.startMessageDOS)
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusMountImg,
                    action: { try Engine.mountDOSImage(imageURL: URL(filePath: image)) }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForDOS(deviceURL: URL(filePath: dev)) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: {
                        try Engine.copyToDevForDOS(
                            imageURL: URL(filePath: image),
                            deviceURL: URL(filePath: dev)
                        )
                    }
                ),
                Action(
                    message: Constants.statusUnmountImg,
                    action: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.ejectVolume(deviceURL: URL(filePath: dev)) }
                ),
                Action(message: Constants.statusSuccess)
            ]
        ).runAll()
    }
}
