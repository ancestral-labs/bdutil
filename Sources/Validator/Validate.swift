//
//  Validate.swift
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

/// Validates command-line inputs before any disk operation is performed.
struct Validate {

    /// Checks that the given device name refers to an accessible block device.
    ///
    /// The device must exist under `/dev/` and be a block device
    /// (`S_IFBLK`), which protects against targeting character devices such as
    /// `/dev/null`.
    ///
    /// - Parameter dev: The device identifier (for example, `disk4`).
    /// - Returns: `true` when the path is an accessible block device.
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

    /// Checks that the given path is an existing, readable file (ISO, DMG, etc.).
    ///
    /// - Parameter path: The file path to validate.
    /// - Returns: `true` when the path exists and is readable.
    public static func isReadableFile(path: String) -> Bool {
        let fm = FileManager.default

        guard fm.fileExists(atPath: path) else {
            return false
        }

        return fm.isReadableFile(atPath: path)
    }
}
