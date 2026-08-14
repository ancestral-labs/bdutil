//
//  ValidateTests.swift
//  bdutil
//
//  Tests for the Validate input validation helpers.
//

import Foundation
import Testing

@testable import bdutil

/// Tests for `Validate.isReadableFile(path:)`.
struct ValidateReadableFileTests {

    /// Verifies that an existing, readable file is accepted.
    @Test func returnsTrueForExistingReadableFile() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bdutil-test-\(UUID().uuidString)")
        try Data("iso-content".utf8).write(to: tmp)
        defer { try? FileManager.default.removeItem(at: tmp) }

        #expect(Validate.isReadableFile(path: tmp.path) == true)
    }

    /// Verifies that a non-existent file is rejected.
    @Test func returnsFalseForNonExistentFile() {
        let path = "/tmp/bdutil-does-not-exist-\(UUID().uuidString)"
        #expect(Validate.isReadableFile(path: path) == false)
    }

    /// Verifies that an empty path is rejected.
    @Test func returnsFalseForEmptyPath() {
        #expect(Validate.isReadableFile(path: "") == false)
    }

    /// Verifies that directories pass the current existence + readability check.
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

/// Tests for `Validate.isDiskDevice(dev:)`.
struct ValidateDiskDeviceTests {

    /// Verifies that a non-existent device is rejected.
    @Test func returnsFalseForNonExistentDevice() {
        #expect(Validate.isDiskDevice(dev: "bdutil-nonexistent-disk-999") == false)
    }

    /// Verifies that an empty device name is rejected.
    @Test func returnsFalseForEmptyDeviceName() {
        #expect(Validate.isDiskDevice(dev: "") == false)
    }

    /// Verifies that a character device is rejected.
    @Test func returnsFalseForRegularFileUnderDev() {
        // /dev/null exists but is a character device, not a block device.
        #expect(Validate.isDiskDevice(dev: "null") == false)
    }

    /// Verifies that another character device is rejected.
    @Test func returnsFalseForCharacterDevice() {
        // /dev/zero is also a character device.
        #expect(Validate.isDiskDevice(dev: "zero") == false)
    }

    /// Verifies that a real block device is accepted.
    @Test func returnsTrueForRootBlockDevice() {
        // The system root disk (disk0) must be a block device on any Mac.
        // If the environment lacks it, this test would fail loudly, which is
        // acceptable since bdutil targets macOS hosts with real disks.
        #expect(Validate.isDiskDevice(dev: "disk0") == true)
    }
}
