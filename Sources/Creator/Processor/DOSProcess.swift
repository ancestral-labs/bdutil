//
//  File.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import BootKit
import Spinner
import ArgumentParser

public enum SchemeArg: String, ExpressibleByArgument {
    case gpt = "gpt"
    case mbr = "mbr"
    
    var toScheme: Scheme {
        switch self {
        case .gpt: return .gpt
        case .mbr: return .mbr
        }
    }
}

public enum FileSystemArg: String, ExpressibleByArgument {
    case fat32 = "fat32"
    case exfat = "exfat"
    
    var toFileSystem: FileSystem {
        switch self {
        case .fat32: return .fat32
        case .exfat: return .exfat
        }
    }
}

class DOSProcess: Process {
    
    let image: String
    let dev: String
    
    let scheme: SchemeArg
    let fileSystem: FileSystemArg
    
    let quiet: Bool
    
    init(image: String, dev: String, scheme: SchemeArg = .gpt, fileSystem: FileSystemArg = .fat32, quiet: Bool) {
        self.image = image
        self.dev = dev
        self.scheme = scheme
        self.fileSystem = fileSystem
        self.quiet = quiet
    }
    
    
    func burn() async {
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
                
        let adviceExFAT: String? = fileSystem == .exfat
                ? Constants.adviceFormatDev
                : nil
        
        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusMountImg,
                    action: { try Engine.mountDOSImage(imageURL: URL(filePath: self.image)) }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForDOS(deviceURL: URL(filePath: self.dev), scheme: self.scheme.toScheme, fileSystem: self.fileSystem.toFileSystem) },
                    advice: adviceExFAT,
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    // action: { try Engine.copyToDevForDOS(imageURL: URL(filePath: self.image), deviceURL: URL(filePath: self.dev)) },
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusUnmountImg,
                    action: { try Engine.unmountDOSImage() }
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
