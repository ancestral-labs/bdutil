//
//  File.swift
//  bclt
//
//  Created by Antonio Izquierdo Álvarez on 3/7/25.
//

import Foundation
import Spinner
import BootKit
import Rainbow

protocol Process {
    
    var dev: String { get }
    
    func burn() async
}

protocol StandardProcess: Process {
    var image: String { get }
}

protocol DarwinProcess: Process {
    var app: String { get }
}

extension Process {
    
    func beep(_ quiet: Bool) {
        
        if !quiet {
            print("\u{07}", terminator: "")
        }
    }
}

class Action {
    
    let message: String
    let advice: String?
    let action: (() async throws -> Void)?
    let onCatch: (() async throws -> Void)?
    
    init(message: String, action: (() async throws -> Void)? = nil, advice: String? = nil, onCatch: (() async throws -> Void)? = nil) {
        self.message = message
        self.action = action
        self.advice = advice
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
        let spins: [Spinner] = actions.map { Spinner(.dots2, $0.message, color: .blue) }
        
        for (action, spin) in zip(actions, spins) {
            
            do {
                
                spin.start()
                try await action.run()
                
            } catch {
                
                if let `catch` = `catch` {
                    `catch`(error, action, spin)
                }
            }
            
            if let advice = action.advice {
                
                spin.warning("\(action.message): \(advice.yellow)")
                
            } else {
                
                spin.success()
            }
        }
    }
}
