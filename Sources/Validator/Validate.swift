//
//  File.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 07/06/2026.
//

import Foundation

struct Validate {

    /// Checks that the given path is a valid disk device (e.g. `disk4`).
    public static func isDiskDevice(dev: String) -> Bool {
        let fm = FileManager.default
        let path = "/dev/\(dev)"

        guard fm.fileExists(atPath: path) else {
            return false
        }

        // Only allow paths under /dev/
        guard path.hasPrefix("/dev/") else {
            return false
        }

        // Verify it's a block device
        var statInfo = stat()
        guard stat(path, &statInfo) == 0 else {
            return false
        }

        return (statInfo.st_mode & S_IFMT) == S_IFBLK
    }

    /// Checks that the given path is an existing, readable regular file (ISO, DMG, etc.).
    public static func isReadableFile(path: String) -> Bool {
        let fm = FileManager.default

        guard fm.fileExists(atPath: path) else {
            return false
        }

        return fm.isReadableFile(atPath: path)
    }
}
