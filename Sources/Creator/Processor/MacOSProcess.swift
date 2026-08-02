//
//  File.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import BootDriveKit

class MacOSProcess: DarwinProcess {
    
    let app: String
    let dev: String
    
    let quiet: Bool
    
    init(app: String, dev: String, quiet: Bool) {
        self.app = app
        self.dev = dev
        self.quiet = quiet
    }
    
    
    func burn() async {
        // ---------------MACOS-------------------
        
            // NEXT Start progress bar with Progress.swift
        // Burn APP (createinstallmedia)
        // Toggle flag to legacy partition
            // Finish progress bar with TerminalUI
        // Print success
            
        print(Constants.startMessageMacOS)
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForMacOS(deviceURL: URL(filePath: self.dev)) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: { try Engine.copyToDevForMacOS(appURL: URL(filePath: self.app)) }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: self.dev)) }
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
