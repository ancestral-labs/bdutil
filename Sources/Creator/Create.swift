//
//  Create.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import BootDriveKit
import Spinner

/// Dispatches a bootable-media creation request to the platform-specific process.
///
/// This is the orchestration entry point shared by the `create dos`,
/// `create unix`, and `create macos` subcommands.
struct Create {

    /// Selects the appropriate process for the requested OS and runs its burn pipeline.
    ///
    /// - Parameters:
    ///   - osType: The operating-system family of the media to create.
    ///   - installer: The path to the image file or macOS installer app.
    ///   - dev: The target disk device identifier (for example, `disk4`).
    ///   - scheme: The partition scheme, used only by the DOS pipeline.
    ///   - fileSystem: The file system, used only by the DOS pipeline.
    ///   - quiet: Suppresses the completion beep when `true`.
    public static func run(
        osType: OSTypes,
        installer: String,
        dev: String,
        scheme: SchemeArg = .gpt,
        fileSystem: FileSystemArg = .fat32,
        quiet: Bool
    ) async {

        let process: Process = switch osType {
        case .dos: DOSProcess(image: installer, dev: dev, scheme: scheme, fileSystem: fileSystem, quiet: quiet)
            case .unix: UnixProcess(image: installer, dev: dev, quiet: quiet)
            case .macos: MacOSProcess(app: installer, dev: dev, quiet: quiet)
        }
        await process.burn()
    }
}
