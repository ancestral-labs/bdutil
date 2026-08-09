//
//  ValidateTests.swift
//  bdutil
//
//  Tests for the Validate input validation helpers.
//

import Foundation
import Testing

@testable import bdutil

struct ValidateReadableFileTests {

    @Test func returnsTrueForExistingReadableFile() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bdutil-test-\(UUID().uuidString)")
        try Data("iso-content".utf8).write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }

        #expect(Validate.isReadableFile(path: tmp.path) == true)
    }

    @Test func returnsFalseForNonExistentFile() {
        let path = "/tmp/bdutil-does-not-exist-\(UUID().uuidString)"
        #expect(Validate.isReadableFile(path: path) == false)
    }

    @Test func returnsFalseForEmptyPath() {
        #expect(Validate.isReadableFile(path: "") == false)
    }

    @Test func returnsTrueForDirectory() throws {
        // Directories exist and are readable; the current implementation
        // only checks existence + readability.
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bdutil-test-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        #expect(Validate.isReadableFile(path: tmp.path) == true)
    }
}

struct ValidateDiskDeviceTests {

    @Test func returnsFalseForNonExistentDevice() {
        #expect(Validate.isDiskDevice(dev: "bdutil-nonexistent-disk-999") == false)
    }

    @Test func returnsFalseForEmptyDeviceName() {
        #expect(Validate.isDiskDevice(dev: "") == false)
    }

    @Test func returnsFalseForRegularFileUnderDev() {
        // /dev/null exists but is a character device, not a block device.
        #expect(Validate.isDiskDevice(dev: "null") == false)
    }

    @Test func returnsFalseForCharacterDevice() {
        // /dev/zero is also a character device.
        #expect(Validate.isDiskDevice(dev: "zero") == false)
    }

    @Test func returnsTrueForRootBlockDevice() {
        // The system root disk (disk0) must be a block device on any Mac.
        // If the environment lacks it, this test would fail loudly, which is
        // acceptable since bdutil targets macOS hosts with real disks.
        #expect(Validate.isDiskDevice(dev: "disk0") == true)
    }
}
