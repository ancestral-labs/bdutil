//
//  File.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import BootKit

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
        
            // TODO NEXT Start progress bar with Progress.swift
        // TODO Burn APP (createinstallmedia)
        // TODO Toggle flag to legacy partition
            // TODO Finish progress bar with TerminalUI
        // TODO Print success
            
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
