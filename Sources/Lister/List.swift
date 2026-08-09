//
//  List.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 06/07/2026.
//

import Foundation
import BootDriveKit
import Table

struct List {

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
    
    public static func roundToGigabytes(bytes: Int) -> Int {
        let divisor: UInt64 = 1_000_000_000  // 1 GB = 10⁹ bytes
        let quotient = UInt64(bytes) / divisor
        let remainder = UInt64(bytes) % divisor
        
        // Redondeo al entero más cercano:
        // si el resto es mayor o igual a la mitad del divisor, se suma 1 al cociente
        return Int(quotient + (remainder >= divisor / 2 ? 1 : 0))
    }
}
