//
//  UtilityTests.swift
//  bdutil
//
//  Tests for Constants, Term, CommandInterface and CommandConf.
//

import Foundation
import Testing

@testable import bdutil

struct ConstantsTests {

    @Test func defaultCommandValues() {
        #expect(Constants.defCommandName == "unknown")
        #expect(Constants.defCommandAbstract == "No command description")
        #expect(Constants.defCommandVersion == "0.0.0")
    }

    @Test func propertyFileConfiguration() {
        #expect(Constants.propertyFileName == "Properties")
        #expect(Constants.propertyFileExtension == "plist")
        #expect(Constants.propertyCLIDictionary == "Interfaces")
    }

    @Test func errorMessagesAreNotEmpty() {
        #expect(!Constants.propertyNFMsg.isEmpty)
        #expect(!Constants.propertyNRMsg.isEmpty)
        #expect(!Constants.propertyWFMsg.isEmpty)
        #expect(!Constants.msgUnexpectedError.isEmpty)
    }

    @Test func statusMessagesAreNotEmpty() {
        #expect(!Constants.statusCheckPrivs.isEmpty)
        #expect(!Constants.statusMountImg.isEmpty)
        #expect(!Constants.statusFormatDev.isEmpty)
        #expect(!Constants.statusCopyFiles.isEmpty)
        #expect(!Constants.statusUnmountImg.isEmpty)
        #expect(!Constants.statusEjectVolume.isEmpty)
        #expect(!Constants.statusSuccess.isEmpty)
    }

    @Test func argumentHelpMessagesAreNotEmpty() {
        #expect(!Constants.argHelpScheme.isEmpty)
        #expect(!Constants.argHelpFileSystem.isEmpty)
        #expect(!Constants.argHelpImg.isEmpty)
        #expect(!Constants.argHelpApp.isEmpty)
        #expect(!Constants.argHelpDev.isEmpty)
        #expect(!Constants.argQuiet.isEmpty)
    }
}

struct TermTests {

    @Test func allCasesCount() {
        #expect(Term.allCases.count == 3)
    }

    @Test func keysMatchCommandConfRawValues() {
        #expect(Term.name.key == CommandConf.name.rawValue)
        #expect(Term.description.key == CommandConf.abstract.rawValue)
        #expect(Term.version.key == CommandConf.version.rawValue)
    }

    @Test func defaultValuesMatchConstants() {
        #expect(Term.name.defValue == Constants.defCommandName)
        #expect(Term.description.defValue == Constants.defCommandAbstract)
        #expect(Term.version.defValue == Constants.defCommandVersion)
    }
}

struct CommandInterfaceTests {

    @Test func allCasesCount() {
        #expect(CommandInterface.allCases.count == 6)
    }

    @Test func rawValues() {
        #expect(CommandInterface.main.rawValue == "Main")
        #expect(CommandInterface.lister.rawValue == "Lister")
        #expect(CommandInterface.creator.rawValue == "Creator")
        #expect(CommandInterface.dos.rawValue == "DOS")
        #expect(CommandInterface.unix.rawValue == "Unix")
        #expect(CommandInterface.macos.rawValue == "MacOS")
    }
}

struct CommandConfTests {

    @Test func allCasesCount() {
        #expect(CommandConf.allCases.count == 3)
    }

    @Test func rawValues() {
        #expect(CommandConf.name.rawValue == "Name")
        #expect(CommandConf.abstract.rawValue == "Abstract")
        #expect(CommandConf.version.rawValue == "Version")
    }
}
