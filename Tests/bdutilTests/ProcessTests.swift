//
//  ProcessTests.swift
//  bdutil
//
//  Tests for the Action/Scheduler process pipeline.
//

import Foundation
import Testing

@testable import bdutil

struct ActionTests {

    @Test func storesMessageAndAdvice() {
        let action = Action(message: "Doing something", advice: "Be careful")
        #expect(action.message == "Doing something")
        #expect(action.advice == "Be careful")
    }

    @Test func runsActionClosure() async throws {
        let ran = MutexBox(false)
        let action = Action(message: "Run") {
            ran.set(true)
        }
        try await action.run()
        #expect(ran.get() == true)
    }

    @Test func runsWithoutClosure() async throws {
        // An action with no closure should complete without throwing.
        let action = Action(message: "No-op")
        try await action.run()
    }

    @Test func rethrowsActionError() async {
        struct TestError: Error {}
        let action = Action(message: "Fail") {
            throw TestError()
        }
        await #expect(throws: TestError.self) {
            try await action.run()
        }
    }

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

struct SchedulerTests {

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
