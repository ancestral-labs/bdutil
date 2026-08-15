//
//  ProcessTests.swift
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
//  Tests for the Action/Scheduler process pipeline.
//

import Foundation
import Testing

@testable import bdutil

/// Tests for the `Action` pipeline step.
struct ActionTests {

    /// Verifies that the message and advice are stored.
    @Test func storesMessageAndAdvice() {
        let action = Action(message: "Doing something", advice: "Be careful")
        #expect(action.message == "Doing something")
        #expect(action.advice == "Be careful")
    }

    /// Verifies that the action closure is executed.
    @Test func runsActionClosure() async throws {
        let ran = MutexBox(false)
        let action = Action(message: "Run") {
            ran.set(true)
        }
        try await action.run()
        #expect(ran.get() == true)
    }

    /// Verifies that an action without a closure completes successfully.
    @Test func runsWithoutClosure() async throws {
        // An action with no closure should complete without throwing.
        let action = Action(message: "No-op")
        try await action.run()
    }

    /// Verifies that an error thrown by the action is rethrown.
    @Test func rethrowsActionError() async {
        struct TestError: Error {}
        let action = Action(message: "Fail") {
            throw TestError()
        }
        await #expect(throws: TestError.self) {
            try await action.run()
        }
    }

    /// Verifies that `onCatch` runs before the error is rethrown.
    @Test func runsOnCatchBeforeRethrowing() async {
        struct TestError: Error {}
        let caught = MutexBox(false)
        let action = Action(
            message: "Fail",
            action: { throw TestError() },
            onCatch: { caught.set(true) }
        )
        await #expect(throws: TestError.self) {
            try await action.run()
        }
        #expect(caught.get() == true)
    }

    /// Verifies that `onCatch` is not invoked on success.
    @Test func doesNotRunOnCatchOnSuccess() async throws {
        let caught = MutexBox(false)
        let action = Action(
            message: "Succeed",
            action: {},
            onCatch: { caught.set(true) }
        )
        try await action.run()
        #expect(caught.get() == false)
    }

    /// Verifies that an error thrown by `onCatch` takes precedence.
    @Test func rethrowsOnCatchError() async {
        struct TestError: Error {}
        struct CatchError: Error {}
        let action = Action(
            message: "Fail",
            action: { throw TestError() },
            onCatch: { throw CatchError() }
        )
        await #expect(throws: CatchError.self) {
            try await action.run()
        }
    }
}

/// Tests for the `Scheduler` pipeline runner.
struct SchedulerTests {

    /// Verifies that the scheduler retains its actions in order.
    @Test func storesActions() {
        let actions = [Action(message: "A"), Action(message: "B")]
        let scheduler = Scheduler(actions: actions)
        #expect(scheduler.actions.count == 2)
        #expect(scheduler.actions[0].message == "A")
        #expect(scheduler.actions[1].message == "B")
    }
}

/// Minimal thread-safe box for capturing state across async closures in tests.
private final class MutexBox<T: Sendable>: @unchecked Sendable {
    private var value: T
    private let lock = NSLock()

    init(_ value: T) {
        self.value = value
    }

    func set(_ newValue: T) {
        lock.lock()
        value = newValue
        lock.unlock()
    }

    func get() -> T {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
}
