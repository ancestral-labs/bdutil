//
//  ArgumentTests.swift
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
//  Tests for CLI argument enums and command configuration.
//

import Foundation
import Testing
import ArgumentParser

@testable import bdutil

/// Tests for the `SchemeArg` partition-scheme option.
struct SchemeArgTests {

    /// Verifies the raw string values used on the command line.
    @Test func rawValues() {
        #expect(SchemeArg.gpt.rawValue == "gpt")
        #expect(SchemeArg.mbr.rawValue == "mbr")
    }

    /// Verifies parsing from command-line strings, including invalid input.
    @Test func expressibleByArgumentParsing() {
        #expect(SchemeArg(argument: "gpt") == .gpt)
        #expect(SchemeArg(argument: "mbr") == .mbr)
        #expect(SchemeArg(argument: "GPT") == nil)
        #expect(SchemeArg(argument: "invalid") == nil)
    }

    /// Verifies mapping to the engine's scheme type.
    @Test func mapsToEngineScheme() {
        #expect(SchemeArg.gpt.toScheme == .gpt)
        #expect(SchemeArg.mbr.toScheme == .mbr)
    }
}

/// Tests for the `FileSystemArg` file-system option.
struct FileSystemArgTests {

    /// Verifies the raw string values used on the command line.
    @Test func rawValues() {
        #expect(FileSystemArg.fat32.rawValue == "fat32")
        #expect(FileSystemArg.exfat.rawValue == "exfat")
    }

    /// Verifies parsing from command-line strings, including invalid input.
    @Test func expressibleByArgumentParsing() {
        #expect(FileSystemArg(argument: "fat32") == .fat32)
        #expect(FileSystemArg(argument: "exfat") == .exfat)
        #expect(FileSystemArg(argument: "FAT32") == nil)
        #expect(FileSystemArg(argument: "ntfs") == nil)
    }

    /// Verifies mapping to the engine's file-system type.
    @Test func mapsToEngineFileSystem() {
        #expect(FileSystemArg.fat32.toFileSystem == .fat32)
        #expect(FileSystemArg.exfat.toFileSystem == .exfat)
    }
}

/// Tests for the `OSTypes` operating-system families.
struct OSTypesTests {

    /// Verifies the raw string values of each OS type.
    @Test func rawValues() {
        #expect(OSTypes.dos.rawValue == "dos")
        #expect(OSTypes.unix.rawValue == "unix")
        #expect(OSTypes.macos.rawValue == "macos")
    }
}

/// Tests for the `Application` command hierarchy.
struct CommandConfigurationTests {

    /// Verifies the root command's name, description, version, and subcommands.
    @Test func applicationConfiguration() {
        #expect(Application.configuration.commandName == "bdutil")
        #expect(Application.configuration.abstract == "Boot Drive Utility")
        #expect(Application.configuration.version == "0.1.0")
        #expect(Application.configuration.subcommands.count == 2)
        #expect(Application.configuration.defaultSubcommand == Application.CreateCommand.self)
    }

    /// Verifies the `create` subcommand and its child commands.
    @Test func createCommandConfiguration() {
        #expect(Application.CreateCommand.configuration.commandName == "create")
        #expect(Application.CreateCommand.configuration.subcommands.count == 3)
    }

    /// Verifies the `list` subcommand name.
    @Test func listCommandConfiguration() {
        #expect(Application.ListCommand.configuration.commandName == "list")
    }

    /// Verifies the `create dos` subcommand name.
    @Test func dosCommandConfiguration() {
        #expect(Application.DOSCommand.configuration.commandName == "dos")
    }

    /// Verifies the `create unix` subcommand name.
    @Test func unixCommandConfiguration() {
        #expect(Application.UnixCommand.configuration.commandName == "unix")
    }

    /// Verifies the `create macos` subcommand name.
    @Test func macosCommandConfiguration() {
        #expect(Application.MacOSCommand.configuration.commandName == "macos")
    }
}

/// Tests for the command-line parameter validation logic.
struct ParameterValidationTests {

    /// Verifies that a missing image file is rejected.
    @Test func standarParametersRejectMissingImage() {
        var params = StandarParameters()
        params.image = "/tmp/bdutil-missing-image-\(UUID().uuidString).iso"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    /// Verifies that an existing image file is accepted.
    @Test func standarParametersAcceptExistingImage() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bdutil-test-\(UUID().uuidString).iso")
        try Data("iso".utf8).write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }

        var params = StandarParameters()
        params.image = tmp.path
        try params.validate()
    }

    /// Verifies that a missing installer app is rejected.
    @Test func darwinParametersRejectMissingApp() {
        var params = DarwinParameters()
        params.app = "/tmp/bdutil-missing-app-\(UUID().uuidString).app"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    /// Verifies that a non-existent device is rejected.
    @Test func commonParametersRejectInvalidDevice() {
        var params = CommonParameters()
        params.dev = "bdutil-nonexistent-disk-999"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    /// Verifies that a character device is rejected.
    @Test func commonParametersRejectCharacterDevice() {
        var params = CommonParameters()
        params.dev = "null"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }
}
