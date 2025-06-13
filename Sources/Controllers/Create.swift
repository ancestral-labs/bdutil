//
//  Run.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import PhaseKit
import AppKit

struct Create {
    
    public static func run(osType: OSTypes, image: String, dev: String) async {
        
        switch osType {
        case .dos:
            await burnDOS(image: image, dev: dev)
        case .unix:
            await burnUNIX(image: image, dev: dev)
        case .macos:
            await burnMacOS(image: image, dev: dev)
        }
    }
    
    private static func burnDOS(image: String, dev: String) async {
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
        do {
            
            print("🔐 Checking user privileges…")
            try Engine.checkPrivileges()
            
            print("💿 Mounting image…")
            try Engine.mountDOSImage(imageURL: URL(filePath: image))
            
            print("🧹 Formatting device…")
            try Engine.formatDeviceForDOS(deviceURL: URL(filePath: dev))
            
            print("📑 Copying files…")
            try Engine.copyToDevForDOS(imageURL: URL(filePath: image), deviceURL: URL(filePath: dev))
            
            print("⏹️ Unmounting image…")
            try Engine.unmountDOSImage()
            
            print("🔌 Ejecting volume…")
            try await Engine.ejectVolume(deviceURL: URL(filePath: dev))
            
            print("🔥 Bootable media created successfully!")
            
        } catch let error as EngineError {
            
            switch error {
            case .notPermitted(let code, let message),
                    .mount(let code, let message),
                    .format(let code, let message),
                    .copy(let code, let message),
                    .ejectVolume(let code, let message),
                    .unmountImage(let code, let message):
                handleEngineError(message: message, code: code)
            }
        } catch {
            handleEngineError(message: "Unexpected error", code: 1)
        }
    }
    
    private static func burnUNIX(image: String, dev: String) async {
        // ---------------UNIX-------------------
        
        // TODO NEXT Start progress bar with Progress.swift
        // TODO Convert ISO to IMG
        // TODO Burn IMG (dd)
        // TODO Toggle flag to legacy partition
        // TODO Finish progress bar with TerminalUI
        // TODO Print success
        do {
                        
            print("🧹 Formatting device…")
            try Engine.formatDeviceForUNIX(deviceURL: URL(filePath: dev))
            
            print("📑 Copying files…")
            try Engine.copyToDevForUNIX(isoURL: URL(filePath: image), devURL: URL(filePath: dev))
            
            print("🔌 Ejecting volume…")
            try await Engine.ejectVolume(deviceURL: URL(filePath: dev))
            
            print("🔥 Bootable media created successfully!")
            
        } catch let error as EngineError {
            
            switch error {
            case .notPermitted(let code, let message),
                    .mount(let code, let message),
                    .format(let code, let message),
                    .copy(let code, let message),
                    .ejectVolume(let code, let message),
                    .unmountImage(let code, let message):
                handleEngineError(message: message, code: code)
            }
        } catch {
            handleEngineError(message: "Unexpected error", code: 1)
        }
    }
    
    private static func burnMacOS(image: String, dev: String) async {
        // ---------------MACOS-------------------
        
            // TODO NEXT Start progress bar with Progress.swift
        // TODO Burn APP (createinstallmedia)
        // TODO Toggle flag to legacy partition
            // TODO Finish progress bar with TerminalUI
        // TODO Print success
        do {
                        
            print("🧹 Formatting device…")
            try Engine.formatDeviceForMacOS(deviceURL: URL(filePath: dev))
            
            print("📑 Copying files…")
            try Engine.copyToDevForMacOS(appURL: URL(filePath: image))
            
            print("🔌 Ejecting volume…")
            try await Engine.ejectVolume(deviceURL: URL(filePath: dev))
            
            print("🔥 Bootable media created successfully!")
            
        } catch let error as EngineError {
            
            switch error {
            case .notPermitted(let code, let message),
                    .mount(let code, let message),
                    .format(let code, let message),
                    .copy(let code, let message),
                    .ejectVolume(let code, let message),
                    .unmountImage(let code, let message):
                handleEngineError(message: message, code: code)
            }
        } catch {
            handleEngineError(message: "Unexpected error", code: 1)
        }
    }
    
    private static func handleEngineError(message: String, code: Int32) {
        print("❌ \(message)")
        exit(code)
    }
}
