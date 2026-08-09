//
//  ArgumentTests.swift
//  bdutil
//
//  Tests for CLI argument enums and command configuration.
//

import Foundation
import Testing
import ArgumentParser

@testable import bdutil

struct SchemeArgTests {

    @Test func rawValues() {
        #expect(SchemeArg.gpt.rawValue == "gpt")
        #expect(SchemeArg.mbr.rawValue == "mbr")
    }

    @Test func expressibleByArgumentParsing() {
        #expect(SchemeArg(argument: "gpt") == .gpt)
        #expect(SchemeArg(argument: "mbr") == .mbr)
        #expect(SchemeArg(argument: "GPT") == nil)
        #expect(SchemeArg(argument: "invalid") == nil)
    }

    @Test func mapsToEngineScheme() {
        #expect(SchemeArg.gpt.toScheme == .gpt)
        #expect(SchemeArg.mbr.toScheme == .mbr)
    }
}

struct FileSystemArgTests {

    @Test func rawValues() {
        #expect(FileSystemArg.fat32.rawValue == "fat32")
        #expect(FileSystemArg.exfat.rawValue == "exfat")
    }

    @Test func expressibleByArgumentParsing() {
        #expect(FileSystemArg(argument: "fat32") == .fat32)
        #expect(FileSystemArg(argument: "exfat") == .exfat)
        #expect(FileSystemArg(argument: "FAT32") == nil)
        #expect(FileSystemArg(argument: "ntfs") == nil)
    }

    @Test func mapsToEngineFileSystem() {
        #expect(FileSystemArg.fat32.toFileSystem == .fat32)
        #expect(FileSystemArg.exfat.toFileSystem == .exfat)
    }
}

struct OSTypesTests {

    @Test func rawValues() {
        #expect(OSTypes.dos.rawValue == "dos")
        #expect(OSTypes.unix.rawValue == "unix")
        #expect(OSTypes.macos.rawValue == "macos")
    }
}

struct CommandConfigurationTests {

    @Test func applicationConfiguration() {
        #expect(Application.configuration.commandName == "bdutil")
        #expect(Application.configuration.abstract == "Boot Drive Utility")
        #expect(Application.configuration.version == "0.0.1")
        #expect(Application.configuration.subcommands.count == 2)
        #expect(Application.configuration.defaultSubcommand == Application.CreateCommand.self)
    }

    @Test func createCommandConfiguration() {
        #expect(Application.CreateCommand.configuration.commandName == "create")
        #expect(Application.CreateCommand.configuration.subcommands.count == 3)
    }

    @Test func listCommandConfiguration() {
        #expect(Application.ListCommand.configuration.commandName == "list")
    }

    @Test func dosCommandConfiguration() {
        #expect(Application.DOSCommand.configuration.commandName == "dos")
    }

    @Test func unixCommandConfiguration() {
        #expect(Application.UnixCommand.configuration.commandName == "unix")
    }

    @Test func macosCommandConfiguration() {
        #expect(Application.MacOSCommand.configuration.commandName == "macos")
    }
}

struct ParameterValidationTests {

    @Test func standarParametersRejectMissingImage() {
        var params = StandarParameters()
        params.image = "/tmp/bdutil-missing-image-\(UUID().uuidString).iso"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    @Test func standarParametersAcceptExistingImage() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bdutil-test-\(UUID().uuidString).iso")
        try Data("iso".utf8).write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }

        var params = StandarParameters()
        params.image = tmp.path
        try params.validate()
    }

    @Test func darwinParametersRejectMissingApp() {
        var params = DarwinParameters()
        params.app = "/tmp/bdutil-missing-app-\(UUID().uuidString).app"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    @Test func commonParametersRejectInvalidDevice() {
        var params = CommonParameters()
        params.dev = "bdutil-nonexistent-disk-999"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }

    @Test func commonParametersRejectCharacterDevice() {
        var params = CommonParameters()
        params.dev = "null"
        #expect(throws: ValidationError.self) {
            try params.validate()
        }
    }
}
