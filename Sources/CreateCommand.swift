//
//  CreateCommand.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import ArgumentParser
import BootDriveKit


/// The operating-system families supported by the `create` subcommand.
public enum OSTypes: String {
    /// Windows/DOS-based bootable media.
    case dos = "dos"
    /// Linux and other UNIX-like bootable media.
    case unix = "unix"
    /// macOS installer bootable media.
    case macos = "macos"
}

/// The common positional arguments for image-based creation commands.
///
/// These parameters are shared by the `dos` and `unix` subcommands.
struct StandarParameters: ParsableArguments {

    /// The path to the disc image file (for example, a `.iso` or `.dmg` file).
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpImg))
    var image: String

    /// Validates that the image path exists and is readable.
    ///
    /// - Throws: A `ValidationError` when the image does not exist or is not readable.
    func validate() throws {

        guard Validate.isReadableFile(path: image) else {
            throw ValidationError("The image file '\(image)' does not exist or is not readable.")
        }
    }
}

/// The positional arguments for the macOS installer-based creation command.
struct DarwinParameters: ParsableArguments {

    /// The path to the macOS installer app (for example, `Install macOS.app`).
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpApp))
    var app: String

    /// Validates that the installer app path exists and is readable.
    ///
    /// - Throws: A `ValidationError` when the app does not exist or is not readable.
    func validate() throws {

        guard Validate.isReadableFile(path: app) else {
            throw ValidationError("The installer app '\(app)' does not exist or is not readable.")
        }
    }
}

/// The common arguments shared by every `create` subcommand.
struct CommonParameters: ParsableArguments {

    /// The target disk device identifier (for example, `disk4`).
    @Argument(help: ArgumentHelp(stringLiteral: Constants.argHelpDev))
    var dev: String

    /// Suppresses the completion beep when `true`.
    @Flag(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argQuiet))
    var quiet: Bool = false

    /// Validates that the device identifier refers to an accessible block device.
    ///
    /// - Throws: A `ValidationError` when the device does not exist or is inaccessible.
    func validate() throws {

        guard Validate.isDiskDevice(dev: dev) else {
            throw ValidationError("The device '/dev/\(dev)' does not exist or is inaccessible.")
        }
    }
}

extension Application {

    /// The `create` subcommand, which groups the per-OS creation commands.
    struct CreateCommand: AsyncParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: PMap.creator[.name],
            abstract: PMap.creator[.description],
            subcommands: [DOSCommand.self, UnixCommand.self, MacOSCommand.self]
        )
    }

    /// Creates bootable Windows (DOS/UEFI) media from an ISO image.
    struct DOSCommand: AsyncParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: PMap.dos[.name],
            abstract: PMap.dos[.description]
        )

        /// The image and its associated validation.
        @OptionGroup()
        var standar: StandarParameters

        /// The target device and shared flags.
        @OptionGroup()
        var common: CommonParameters

        /// The partition scheme to apply to the target device.
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpScheme))
        var scheme: SchemeArg = .gpt

        /// The file system to use on the target device.
        @Option(name: .shortAndLong, help: ArgumentHelp(stringLiteral: Constants.argHelpFileSystem))
        var fileSystem: FileSystemArg = .fat32

        /// Runs the DOS media creation pipeline.
        func run() async {

            await Create.run(osType: .dos, installer: standar.image, dev: common.dev, scheme: scheme, fileSystem: fileSystem, quiet: common.quiet)
        }
    }

    /// Creates bootable Linux/UNIX media from an ISO image.
    struct UnixCommand: AsyncParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: PMap.unix[.name],
            abstract: PMap.unix[.description]
        )

        /// The image and its associated validation.
        @OptionGroup()
        var standar: StandarParameters

        /// The target device and shared flags.
        @OptionGroup()
        var common: CommonParameters

        /// Runs the UNIX media creation pipeline.
        func run() async {

            await Create.run(osType: .unix, installer: standar.image, dev: common.dev, quiet: common.quiet)
        }
    }

    /// Creates bootable macOS installer media from an installer app or DMG.
    struct MacOSCommand: AsyncParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: PMap.macos[.name],
            abstract: PMap.macos[.description]
        )

        /// The macOS installer app and its associated validation.
        @OptionGroup()
        var darwin: DarwinParameters

        /// The target device and shared flags.
        @OptionGroup()
        var common: CommonParameters

        /// Runs the macOS media creation pipeline.
        func run() async {

            await Create.run(osType: .macos, installer: darwin.app, dev: common.dev, quiet: common.quiet)
        }
    }
}
