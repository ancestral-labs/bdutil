//
//  Run.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import BootKit
import Spinner

struct Create {
    
    public static func run(
        osType: OSTypes,
        installer: String,
        dev: String,
        scheme: SchemeArg = .gpt,
        fileSystem: FileSystemArg = .fat32,
        quiet: Bool
    ) async {
                
        let process: Process = switch osType {
        case .dos: DOSProcess(image: installer, dev: dev, scheme: scheme, fileSystem: fileSystem, quiet: quiet)
            case .unix: UnixProcess(image: installer, dev: dev, quiet: quiet)
            case .macos: MacOSProcess(app: installer, dev: dev, quiet: quiet)
        }
        await process.burn()
    }
}
