//
//  Constants.swift
//  bdutil
//
//  Copyright 2023-2026 Ancestral Labs
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

/// The command interfaces described in the bundled `Properties.plist`.
public enum CommandInterface: String, CaseIterable {
    /// The root `bdutil` command.
    case main = "Main"
    /// The `list` subcommand.
    case lister = "Lister"
    /// The `create` subcommand.
    case creator = "Creator"
    /// The `create dos` subcommand.
    case dos = "DOS"
    /// The `create unix` subcommand.
    case unix = "Unix"
    /// The `create macos` subcommand.
    case macos = "MacOS"
}

/// The metadata keys read from each command interface entry.
public enum CommandConf: String, CaseIterable {
    /// The command name (for example, `create`).
    case name = "Name"
    /// A short human-readable description.
    case abstract = "Abstract"
    /// The version string, only used by the root command.
    case version = "Version"
}

/// Localized, user-facing strings and configuration constants for `bdutil`.
struct Constants {

    // MARK: Command defaults

    /// Fallback command name used when a property is missing.
    public static let defCommandName: String = "unknown"
    /// Fallback description used when a property is missing.
    public static let defCommandAbstract: String = "No command description"
    /// Fallback version used when a property is missing.
    public static let defCommandVersion: String = "0.0.0"

    // MARK: Property file

    /// The base name of the bundled properties resource.
    public static let propertyFileName: String = "Properties"
    /// The extension of the bundled properties resource.
    public static let propertyFileExtension: String = "plist"

    /// The top-level dictionary key holding the command interfaces.
    public static let propertyCLIDictionary: String = "Interfaces"

    // MARK: Property error messages

    /// Error shown when the properties file cannot be located.
    public static let propertyNFMsg: String = "Property file not found"
    /// Error shown when the properties file cannot be read.
    public static let propertyNRMsg: String = "Property file not reachable"
    /// Error shown when the properties file has an unexpected structure.
    public static let propertyWFMsg: String = "Wrong property file format"

    // MARK: Argument help text

    /// Help text for the partition scheme option.
    public static let argHelpScheme: String = "Partition scheme: gpt or mbr"
    /// Help text for the file system option.
    public static let argHelpFileSystem: String = "File system: fat32 or exfat (fat32 the most compatible)"
    /// Help text for the image path argument.
    public static let argHelpImg: String = "Disc image file path"
    /// Help text for the installer app argument.
    public static let argHelpApp: String = "Installer app file path"
    /// Help text for the device path argument.
    public static let argHelpDev: String = "Disk node identifier"
    /// Help text for the quiet flag.
    public static let argQuiet: String = "Avoid beep after creating media"

    // MARK: Start messages

    /// Message shown when starting DOS media creation.
    public static let startMessageDOS: String = "Creating DOS bootable device"
    /// Message shown when starting UNIX media creation.
    public static let startMessageUNIX: String = "Creating UNIX bootable device"
    /// Message shown when starting macOS media creation.
    public static let startMessageMacOS: String = "Creating macOS bootable device"

    // MARK: Pipeline status messages

    /// Status shown while checking privileges.
    public static let statusCheckPrivs: String = "Checking user privileges"
    /// Status shown while mounting the image.
    public static let statusMountImg: String = "Mounting image"
    /// Status shown while formatting the device.
    public static let statusFormatDev: String = "Formatting device"
    /// Status shown while copying files.
    public static let statusCopyFiles: String = "Copying files"
    /// Status shown while unmounting the image.
    public static let statusUnmountImg: String = "Unmounting image"
    /// Status shown while ejecting the volume.
    public static let statusEjectVolume: String = "Ejecting volume"
    /// Status shown when finishing media creation.
    public static let statusSuccess: String = "Finishing bootable media creation"

    // MARK: Advisory messages

    /// Warning shown when an ExFAT device is selected.
    public static let adviceFormatDev: String = "Most BIOS firmware does not support ExFAT-formatted devices"

    // MARK: Error messages

    /// Generic message shown for unexpected errors.
    public static let msgUnexpectedError: String = "Unexpected error"
}
