//
//  List.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 06/07/2026.
//

import Foundation
import BootDriveKit

struct List {

    public static func run() {
        
        do {
                        
            let drives = try Engine.listDrives()
            
            if drives.isEmpty {
                
                print("No se encontraron discos físicos externos.")
                
            } else {
                
                print("Discos externos montados:")
                
                for drive in drives {
                    
                    print("- \(drive.name)")
                }
            }
            
        } catch let error {
            
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
