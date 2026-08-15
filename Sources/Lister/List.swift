//
//  List.swift
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
import BootDriveKit
import Table

/// Lists the external drives available as bootable-media targets.
struct List {

    /// Prints a table of mounted external drives.
    ///
    /// If no drives are available, a short message is printed instead. Any
    /// error raised while querying the engine is printed to standard error.
    public static func run() {

        do {

            let drives = try Engine.listDrives()

            if drives.isEmpty {

                print("No external drives found.")

            } else {

                print("Mounted external drives:")

                var rows: [[String]] = []

                for drive in drives {

                    let total = roundToGigabytes(bytes: drive.totalSize)

                    rows.append(
                        contentsOf: [[drive.name, drive.id, "\(total) GB"]]
                    )
                }

                struct NullStream: TextOutputStream {
                    func write(_ string: String) {}
                }

                var nullStream = NullStream()
                let tableOutput = print(
                    table: rows,
                    header: ["Name", "Node", "Capacity"],
                    distribution: .fillProportionally,
                    style: .unicode,
                    stream: &nullStream
                )
                print(tableOutput, terminator: "")
            }

        } catch let error {

            print("ERROR: \(error.localizedDescription)")
        }
    }

    /// Converts a byte count to whole gigabytes, rounding to the nearest value.
    ///
    /// - Parameter bytes: The size in bytes.
    /// - Returns: The size rounded to the nearest gigabyte (10⁹ bytes).
    public static func roundToGigabytes(bytes: Int) -> Int {
        let divisor: UInt64 = 1_000_000_000  // 1 GB = 10⁹ bytes
        let quotient = UInt64(bytes) / divisor
        let remainder = UInt64(bytes) % divisor

        // Round to the nearest integer: when the remainder is at least half of
        // the divisor, increment the quotient.
        return Int(quotient + (remainder >= divisor / 2 ? 1 : 0))
    }
}
