//
//  List.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 06/07/2026.
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
