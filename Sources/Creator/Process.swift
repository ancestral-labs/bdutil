//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation

protocol Process {
    func burn(image: String, dev: String) -> String
}

class MacOSProcess: Process {
    func burn(image: String, dev: String) -> String {
        <#code#>
    }
}

class UnixProcess: Process {
    func burn(image: String, dev: String) -> String {
        <#code#>
    }
}

class DOSProcess: Process {
    func burn(image: String, dev: String) -> String {
        <#code#>
    }
}
