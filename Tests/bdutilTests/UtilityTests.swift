//
//  UtilityTests.swift
//  bdutil
//
//  Tests for Constants, Term, CommandInterface and CommandConf.
//

import Foundation
import Testing

@testable import bdutil

/// Tests for the `Constants` configuration and message values.
struct ConstantsTests {

    /// Verifies the default command metadata fallbacks.
    @Test func defaultCommandValues() {
        #expect(Constants.defCommandName == "unknown")
        #expect(Constants.defCommandAbstract == "No command description")
        #expect(Constants.defCommandVersion == "0.0.0")
    }

    /// Verifies the properties-file resource names.
    @Test func propertyFileConfiguration() {
        #expect(Constants.propertyFileName == "Properties")
        #expect(Constants.propertyFileExtension == "plist")
        #expect(Constants.propertyCLIDictionary == "Interfaces")
    }

    /// Verifies that error messages are non-empty.
    @Test func errorMessagesAreNotEmpty() {
        #expect(!Constants.propertyNFMsg.isEmpty)
        #expect(!Constants.propertyNRMsg.isEmpty)
        #expect(!Constants.propertyWFMsg.isEmpty)
        #expect(!Constants.msgUnexpectedError.isEmpty)
    }

    /// Verifies that pipeline status messages are non-empty.
    @Test func statusMessagesAreNotEmpty() {
        #expect(!Constants.statusCheckPrivs.isEmpty)
        #expect(!Constants.statusMountImg.isEmpty)
        #expect(!Constants.statusFormatDev.isEmpty)
        #expect(!Constants.statusCopyFiles.isEmpty)
        #expect(!Constants.statusUnmountImg.isEmpty)
        #expect(!Constants.statusEjectVolume.isEmpty)
        #expect(!Constants.statusSuccess.isEmpty)
    }

    /// Verifies that argument help messages are non-empty.
    @Test func argumentHelpMessagesAreNotEmpty() {
        #expect(!Constants.argHelpScheme.isEmpty)
        #expect(!Constants.argHelpFileSystem.isEmpty)
        #expect(!Constants.argHelpImg.isEmpty)
        #expect(!Constants.argHelpApp.isEmpty)
        #expect(!Constants.argHelpDev.isEmpty)
        #expect(!Constants.argQuiet.isEmpty)
    }
}

/// Tests for the `Term` metadata keys.
struct TermTests {

    /// Verifies the number of metadata terms.
    @Test func allCasesCount() {
        #expect(Term.allCases.count == 3)
    }

    /// Verifies that term keys map to `CommandConf` raw values.
    @Test func keysMatchCommandConfRawValues() {
        #expect(Term.name.key == CommandConf.name.rawValue)
        #expect(Term.description.key == CommandConf.abstract.rawValue)
        #expect(Term.version.key == CommandConf.version.rawValue)
    }

    /// Verifies that term defaults match the `Constants` fallbacks.
    @Test func defaultValuesMatchConstants() {
        #expect(Term.name.defValue == Constants.defCommandName)
        #expect(Term.description.defValue == Constants.defCommandAbstract)
        #expect(Term.version.defValue == Constants.defCommandVersion)
    }
}

/// Tests for the `CommandInterface` command identifiers.
struct CommandInterfaceTests {

    /// Verifies the number of command interfaces.
    @Test func allCasesCount() {
        #expect(CommandInterface.allCases.count == 6)
    }

    /// Verifies the raw string values of each command interface.
    @Test func rawValues() {
        #expect(CommandInterface.main.rawValue == "Main")
        #expect(CommandInterface.lister.rawValue == "Lister")
        #expect(CommandInterface.creator.rawValue == "Creator")
        #expect(CommandInterface.dos.rawValue == "DOS")
        #expect(CommandInterface.unix.rawValue == "Unix")
        #expect(CommandInterface.macos.rawValue == "MacOS")
    }
}

/// Tests for the `CommandConf` metadata keys.
struct CommandConfTests {

    /// Verifies the number of configuration keys.
    @Test func allCasesCount() {
        #expect(CommandConf.allCases.count == 3)
    }

    /// Verifies the raw string values of each configuration key.
    @Test func rawValues() {
        #expect(CommandConf.name.rawValue == "Name")
        #expect(CommandConf.abstract.rawValue == "Abstract")
        #expect(CommandConf.version.rawValue == "Version")
    }
}
