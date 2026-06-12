//
//  File.swift
//  bdutil
//
//  Created by Antonio Izquierdo Álvarez on 07/06/2026.
//

import Foundation

struct Validate {

    public static func run(path: String) -> Bool {
        
        let fm = FileManager.default
        
        return fm.fileExists(atPath: path)
    }
}
