//
//  ListTests.swift
//  bdutil
//
//  Tests for the List helper utilities.
//

import Foundation
import Testing

@testable import bdutil

/// Tests for `List.roundToGigabytes(bytes:)`.
struct RoundToGigabytesTests {

    /// Verifies that zero bytes rounds to zero.
    @Test func zeroBytes() {
        #expect(List.roundToGigabytes(bytes: 0) == 0)
    }

    /// Verifies an exact gigabyte value.
    @Test func exactGigabyte() {
        #expect(List.roundToGigabytes(bytes: 1_000_000_000) == 1)
    }

    /// Verifies an exact multiple of a gigabyte.
    @Test func multipleExactGigabytes() {
        #expect(List.roundToGigabytes(bytes: 16_000_000_000) == 16)
    }

    /// Verifies rounding down when below half a gigabyte.
    @Test func roundsDownBelowHalfGigabyte() {
        // 1.4 GB -> 1 GB
        #expect(List.roundToGigabytes(bytes: 1_400_000_000) == 1)
    }

    /// Verifies rounding up at exactly half a gigabyte.
    @Test func roundsUpAtHalfGigabyte() {
        // 1.5 GB -> 2 GB (remainder >= divisor / 2)
        #expect(List.roundToGigabytes(bytes: 1_500_000_000) == 2)
    }

    /// Verifies rounding up above half a gigabyte.
    @Test func roundsUpAboveHalfGigabyte() {
        // 1.9 GB -> 2 GB
        #expect(List.roundToGigabytes(bytes: 1_900_000_000) == 2)
    }

    /// Verifies that sub-gigabyte values below half round down.
    @Test func subGigabyteRoundsDown() {
        // 499 MB -> 0 GB
        #expect(List.roundToGigabytes(bytes: 499_999_999) == 0)
    }

    /// Verifies that sub-gigabyte values at or above half round up.
    @Test func subGigabyteRoundsUp() {
        // 500 MB -> 1 GB
        #expect(List.roundToGigabytes(bytes: 500_000_000) == 1)
    }

    /// Verifies a large (multi-terabyte) drive size.
    @Test func largeDriveSize() {
        // ~2 TB drive
        #expect(List.roundToGigabytes(bytes: 2_000_000_000_000) == 2000)
    }
}
