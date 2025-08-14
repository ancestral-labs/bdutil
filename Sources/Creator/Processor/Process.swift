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
    
    init(message: String, action: (() async throws -> Void)? = nil) {
        self.message = message
        self.action = action
    }
    
    func run() async throws {
        if let action = action {
            try await action()
        }
    }
}

class Scheduler {
    
    let actions: [Action]
    
    init(actions: [Action]) {
        self.actions = actions
    }
    
    func runAll() async {
                
        // Creates a spinner per action schedule
        let spins: [Spinner] = actions.map { Spinner(.dots2, $0.message, color: .yellow) }
        
        for (action, spin) in zip(actions, spins) {
            
            do {
                
                spin.start()
                try await action.run()
                
            } catch let error as EngineError {
                
                switch error {
                case .notPermitted(let code, let message),
                        .mountImage(let code, let message),
                        .format(let code, let message),
                        .copyFiles(let code, let message),
                        .unmountImage(let code, let message),
                        .ejectVolume(let code, let message):
                    var textMessage: String = message
                    if textMessage.hasPrefix("\n") { textMessage.removeFirst() }
                    if textMessage.hasSuffix("\n") { textMessage.removeLast() }
                    spin.error("\(action.message): \(textMessage.red)")
                    exit(code)
                }
            } catch {
                
                spin.error("\(action.message): \(Constants.msgUnexpectedError.red)")
                exit(1)
            }
            spin.success()
        }
    }
}
