//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import PhaseKit
import Rainbow

protocol Process {
    
    func burn(image: String, dev: String) async
}

extension Process {
    
    func beep() {
        print("\u{07}", terminator: "")
    }
}

class Action {
    
    let message: String
    let action: (() async throws -> Void)?
    let onCatch: (() async throws -> Void)?
    
    init(message: String, action: (() async throws -> Void)? = nil, onCatch: (() async throws -> Void)? = nil) {
        self.message = message
        self.action = action
        self.onCatch = onCatch
    }
    
    func run() async throws {
        
        do {
            
            if let action = action {
                try await action()
            }
        } catch let error {
            
            if let onCatch = onCatch {
                try await onCatch()
            }
            
            throw error
        }
    }
}

class Scheduler {
    
    let actions: [Action]
    
    init(actions: [Action]) {
        self.actions = actions
    }
    
    func runAll(catch: ((_ error: Error, _ action: Action, _ spin: Spinner) -> Void)? = nil) async {
                
        // Creates a spinner per action schedule
        let spins: [Spinner] = actions.map { Spinner(.dots2, $0.message, color: .yellow) }
        
        for (action, spin) in zip(actions, spins) {
            
            do {
                
                spin.start()
                try await action.run()
                
            } catch {
                
                if let `catch` = `catch` {
                    `catch`(error, action, spin)
                }
            }
            spin.success()
        }
    }
}
