//
//  ListTests.swift
//  bdutil
//
//  Tests for the List helper utilities.
//

import Foundation
import Testing

@testable import bdutil

struct RoundToGigabytesTests {

    @Test func zeroBytes() {
        #expect(List.roundToGigabytes(bytes: 0) == 0)
    }

    @Test func exactGigabyte() {
        #expect(List.roundToGigabytes(bytes: 1_000_000_000) == 1)
    }

    @Test func multipleExactGigabytes() {
        #expect(List.roundToGigabytes(bytes: 16_000_000_000) == 16)
    }

    @Test func roundsDownBelowHalfGigabyte() {
        // 1.4 GB -> 1 GB
        #expect(List.roundToGigabytes(bytes: 1_400_000_000) == 1)
    }

    @Test func roundsUpAtHalfGigabyte() {
        // 1.5 GB -> 2 GB (remainder >= divisor / 2)
        #expect(List.roundToGigabytes(bytes: 1_500_000_000) == 2)
    }

    @Test func roundsUpAboveHalfGigabyte() {
        // 1.9 GB -> 2 GB
        #expect(List.roundToGigabytes(bytes: 1_900_000_000) == 2)
    }

    @Test func subGigabyteRoundsDown() {
        // 499 MB -> 0 GB
        #expect(List.roundToGigabytes(bytes: 499_999_999) == 0)
    }

    @Test func subGigabyteRoundsUp() {
        // 500 MB -> 1 GB
        #expect(List.roundToGigabytes(bytes: 500_000_000) == 1)
    }

    @Test func largeDriveSize() {
        // ~2 TB drive
        #expect(List.roundToGigabytes(bytes: 2_000_000_000_000) == 2000)
    }
}
