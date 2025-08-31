//
//  Run.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import PhaseKit
import Spinner

struct Create {
    
    public static func run(osType: OSTypes, image: String, dev: String, scheme: SchemeArg = .gpt, fileSystem: FileSystemArg = .fat32) async {
                
        let process: Process = switch osType {
            case .dos: DOSProcess(image: image, dev: dev, scheme: scheme, fileSystem: fileSystem)
            case .unix: UnixProcess(image: image, dev: dev)
            case .macos: MacOSProcess(image: image, dev: dev)
        }
        await process.burn()
    }
}
