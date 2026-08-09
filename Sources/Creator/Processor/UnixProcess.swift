//
//  File.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import BootDriveKit

class UnixProcess: StandardProcess {
    
    let image: String
    let dev: String
    
    let quiet: Bool
    
    init(image: String, dev: String, quiet: Bool) {
        self.image = image
        self.dev = dev
        self.quiet = quiet
    }
    
    
    func burn() async {
        // ---------------UNIX-------------------
        
        // NEXT Start progress bar with Progress.swift
        // Convert ISO to IMG
        // Burn IMG (dd)
        // Toggle flag to legacy partition
        // Finish progress bar with TerminalUI
        // Print success
            
        print(Constants.startMessageUNIX)
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForUNIX(deviceURL: URL(filePath: "/dev/\(self.dev)")) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: {
                        try Engine.copyToDevForUNIX(
                            isoURL: URL(filePath: self.image),
                            devURL: URL(filePath: "/dev/\(self.dev)")
                        )
                    }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: "/dev/\(self.dev)")) }
                ),
                Action(
                    message: Constants.statusSuccess,
                    action: { self.beep(self.quiet) }
                )
            ]
        ).runAll(
            catch: { error, action, spin in

                handleEngineError(error, action, spin)
            }
        )
    }
}
