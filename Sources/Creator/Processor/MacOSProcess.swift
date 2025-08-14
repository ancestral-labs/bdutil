//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import PhaseKit

class MacOSProcess: Process {
    
    func burn(image: String, dev: String) async {
        // ---------------MACOS-------------------
        
            // TODO NEXT Start progress bar with Progress.swift
        // TODO Burn APP (createinstallmedia)
        // TODO Toggle flag to legacy partition
            // TODO Finish progress bar with TerminalUI
        // TODO Print success
            
        print(Constants.startMessageMacOS)
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForMacOS(deviceURL: URL(filePath: dev)) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: { try Engine.copyToDevForMacOS(appURL: URL(filePath: image)) }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: dev)) }
                ),
                Action(message: Constants.statusSuccess)
            ]
        ).runAll()
    }
}
