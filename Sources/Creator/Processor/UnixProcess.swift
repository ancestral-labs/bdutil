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
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
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
                Action(
                    message: Constants.statusSuccess,
                    action: { self.beep(self.quiet) }
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
                            .ejectVolume(let code, let message),
                            .listDrives(let code, let message):
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
