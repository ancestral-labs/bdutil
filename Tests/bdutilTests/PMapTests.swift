//
//  PMapTests.swift
//  bdutil
//
//  Tests for the PMap property map loaded from Properties.plist.
//

import Foundation
import Testing

@testable import bdutil

struct PMapTests {

    @Test func mainInterfaceValues() {
        #expect(PMap.main[.name] == "bdutil")
        #expect(PMap.main[.description] == "Boot Drive Utility")
        #expect(PMap.main[.version] == "0.0.1")
    }

    @Test func creatorInterfaceValues() {
        #expect(PMap.creator[.name] == "create")
        #expect(PMap.creator[.description] == "Burns the selected OS to the target media device")
    }

    @Test func listerInterfaceValues() {
        #expect(PMap.lister[.name] == "list")
        #expect(PMap.lister[.description] == "List the available drives to be burned ")
    }

    @Test func dosInterfaceValues() {
        #expect(PMap.dos[.name] == "dos")
        #expect(PMap.dos[.description] == "Burns the selected DOS like ISO image to the target media device")
    }

    @Test func unixInterfaceValues() {
        #expect(PMap.unix[.name] == "unix")
        #expect(PMap.unix[.description] == "Burns the selected UNIX like ISO image to the target media device")
    }

    @Test func macosInterfaceValues() {
        #expect(PMap.macos[.name] == "macos")
        #expect(PMap.macos[.description] == "Burns the selected macOS setup app to the target media device")
    }

    @Test func missingVersionFallsBackToDefault() {
        // The plist only defines a Version for the Main interface; the rest
        // must fall back to the default value.
        #expect(PMap.creator[.version] == Constants.defCommandVersion)
        #expect(PMap.lister[.version] == Constants.defCommandVersion)
        #expect(PMap.dos[.version] == Constants.defCommandVersion)
        #expect(PMap.unix[.version] == Constants.defCommandVersion)
        #expect(PMap.macos[.version] == Constants.defCommandVersion)
    }
}
