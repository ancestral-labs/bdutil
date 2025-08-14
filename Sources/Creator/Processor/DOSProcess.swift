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
                // MUST UNMOUNT THE ISO IF FAILS
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForDOS(deviceURL: URL(filePath: dev)) },
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                // MUST UNMOUNT THE ISO IF FAILS
                Action(
                    message: Constants.statusCopyFiles,
                    action: { try Engine.copyToDevForDOS(imageURL: URL(filePath: image), deviceURL: URL(filePath: dev)) },
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusUnmountImg,
                    action: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: dev)) }
                ),
                Action(
                    message: Constants.statusSuccess,
                    action: {
                        self.beep()
                    }
                )
            ]
        ).runAll(
            catch: { error, action, spin in
                
                if let engineError = error as? EngineError {
                    
                    switch engineError {
                    case .notPermitted(let code, let message),
                            .mountImage(let code, let message),
                            .format(let code, let message),
                            .copyFiles(let code, let message),
                            .unmountImage(let code, let message),
                            .ejectVolume(let code, let message):
                        var textMessage: String = message
                        if textMessage.hasPrefix("\n") { textMessage.removeFirst() }
                        if textMessage.hasSuffix("\n") { textMessage.removeLast() }
                        spin.error("\(action.message): \(textMessage.red)")
                        exit(code)
                    }
                } else {
                    
                    spin.error("\(action.message): \(Constants.msgUnexpectedError.red)")
                    exit(1)
                }
            }
        )
    }
}
