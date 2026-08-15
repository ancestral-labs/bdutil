//
//  Process.swift
//  bdutil
//
//  Copyright 2023-2026 Ancestral Labs
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Spinner
import BootDriveKit
import Rainbow

/// A bootable-media creation process.
///
/// Conforming types implement the platform-specific burn pipeline for a
/// target disk device.
protocol Process {

    /// The target disk device identifier.
    var dev: String { get }

    /// Runs the media creation pipeline asynchronously.
    func burn() async
}

/// A process that burns media from a disc image file (ISO/DMG).
protocol StandardProcess: Process {
    /// The path to the source image file.
    var image: String { get }
}

/// A process that burns media from a macOS installer app.
protocol DarwinProcess: Process {
    /// The path to the macOS installer app.
    var app: String { get }
}

extension Process {

    /// Emits a terminal bell unless the process is running in quiet mode.
    ///
    /// - Parameter quiet: When `true`, the bell is suppressed.
    func beep(_ quiet: Bool) {

        if !quiet {
            print("\u{07}", terminator: "")
        }
    }
}

/// Formats and reports an error raised by the `BootDriveKit` engine.
///
/// The message is trimmed of leading/trailing newlines, prefixed with the
/// action's description, and printed as an error before terminating with the
/// engine's exit code.
///
/// - Parameters:
///   - error: The error thrown during an action.
///   - action: The action that raised the error.
///   - spin: The spinner associated with the action.
func handleEngineError(_ error: Error, _ action: Action, _ spin: Spinner) {
    if let engineError = error as? EngineError {

        switch engineError {
        case .notPermitted(let code, let message),
                .mountImage(let code, let message),
                .format(let code, let message),
                .copyFiles(let code, let message),
                .unmountImage(let code, let message),
                .ejectVolume(let code, let message),
                .listDrives(let code, let message):
            var textMessage: String = message
            if textMessage.hasPrefix("\n") { textMessage.removeFirst() }
            if textMessage.hasSuffix("\n") { textMessage.removeLast() }
            spin.error("\(action.message): \(textMessage.red)")
            exit(code)
        }
    } else {

        spin.error("\(action.message): \(Constants.msgUnexpectedError.red)")
        exit(1)
    }
}

/// A single step in a media creation pipeline.
///
/// An action wraps an optional asynchronous operation, an optional cleanup
/// closure to run when the operation fails, and an optional advisory message
/// shown to the user after the step completes.
class Action {

    /// The human-readable description shown by the spinner.
    let message: String
    /// An optional advisory message shown after the step completes.
    let advice: String?
    /// The asynchronous operation to perform.
    let action: (() async throws -> Void)?
    /// An optional cleanup closure invoked when `action` throws.
    let onCatch: (() async throws -> Void)?

    /// Creates a pipeline action.
    ///
    /// - Parameters:
    ///   - message: The description shown by the spinner.
    ///   - action: The asynchronous operation to perform, or `nil` for a no-op.
    ///   - advice: An optional advisory message shown after the step.
    ///   - onCatch: An optional cleanup closure run when `action` throws.
    init(message: String, action: (() async throws -> Void)? = nil, advice: String? = nil, onCatch: (() async throws -> Void)? = nil) {
        self.message = message
        self.action = action
        self.advice = advice
        self.onCatch = onCatch
    }

    /// Runs the action, invoking `onCatch` before rethrowing on failure.
    ///
    /// - Throws: The error thrown by `action`, or by `onCatch` if cleanup itself fails.
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

/// Runs a sequence of actions while reporting progress with spinners.
class Scheduler {

    let actions: [Action]

    /// Creates a scheduler for the given actions.
    ///
    /// - Parameter actions: The ordered list of actions to execute.
    init(actions: [Action]) {
        self.actions = actions
    }

    /// Executes each action in order, updating an associated spinner.
    ///
    /// If an action fails, the provided `catch` closure is invoked with the
    /// error, the failed action, and its spinner.
    ///
    /// - Parameter catch: A closure invoked when an action throws.
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
                continue
            }

            if let advice = action.advice {

                spin.warning("\(action.message): \(advice.yellow)")

            } else {

                spin.success()
            }
        }
    }
}
