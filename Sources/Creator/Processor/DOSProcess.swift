//
//  DOSProcess.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import BootDriveKit
import Spinner
import ArgumentParser

/// The partition schemes supported for DOS (Windows) bootable media.
public enum SchemeArg: String, ExpressibleByArgument {
    /// GUID Partition Table (UEFI).
    case gpt = "gpt"
    /// Master Boot Record (legacy BIOS).
    case mbr = "mbr"

    /// The corresponding `BootDriveKit` engine scheme.
    var toScheme: Engine.Scheme {
        switch self {
        case .gpt: return .gpt
        case .mbr: return .mbr
        }
    }
}

/// The file systems supported for DOS (Windows) bootable media.
public enum FileSystemArg: String, ExpressibleByArgument {
    /// FAT32 — the most compatible option.
    case fat32 = "fat32"
    /// ExFAT — less compatible with BIOS firmware.
    case exfat = "exfat"

    /// The corresponding `BootDriveKit` engine file system.
    var toFileSystem: Engine.FileSystem {
        switch self {
        case .fat32: return .fat32
        case .exfat: return .exfat
        }
    }
}

/// Creates bootable Windows (DOS/UEFI) media from an ISO image.
class DOSProcess: StandardProcess {

    let image: String
    let dev: String

    let scheme: SchemeArg
    let fileSystem: FileSystemArg

    let quiet: Bool

    /// Creates a DOS media-creation process.
    ///
    /// - Parameters:
    ///   - image: The path to the Windows ISO image.
    ///   - dev: The target disk device identifier.
    ///   - scheme: The partition scheme to apply (defaults to `.gpt`).
    ///   - fileSystem: The file system to use (defaults to `.fat32`).
    ///   - quiet: Suppresses the completion beep when `true`.
    init(image: String, dev: String, scheme: SchemeArg = .gpt, fileSystem: FileSystemArg = .fat32, quiet: Bool) {
        self.image = image
        self.dev = dev
        self.scheme = scheme
        self.fileSystem = fileSystem
        self.quiet = quiet
    }


    /// Runs the Windows media creation pipeline.
    ///
    /// The pipeline checks privileges, mounts the ISO, formats the device,
    /// copies files, unmounts the image, ejects the volume, and signals success.
    func burn() async {
        // ---------------WINDOWS-------------------

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
                    action: { try Engine.formatDeviceForDOS(deviceURL: URL(filePath: "/dev/\(self.dev)"), scheme: self.scheme.toScheme, fileSystem: self.fileSystem.toFileSystem) },
                    advice: adviceExFAT,
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: { try Engine.copyToDevForDOS(imageURL: URL(filePath: self.image), deviceURL: URL(filePath: "/dev/\(self.dev)")) },
                    onCatch: { try Engine.unmountDOSImage() }
                ),
                Action(
                    message: Constants.statusUnmountImg,
                    action: { try Engine.unmountDOSImage() }
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
