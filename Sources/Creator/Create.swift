//
//  Run.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import PhaseKit
import Spinner

struct Create {
    
    public static func run(osType: OSTypes, image: String, dev: String) async {
                
        let process: Process = switch osType {
            case .dos: DOSProcess()
            case .unix: UnixProcess()
            case .macos: MacOSProcess()
        }
        await process.burn(image: image, dev: dev)
    }
}
