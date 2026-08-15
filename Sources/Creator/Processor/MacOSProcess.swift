//
//  MacOSProcess.swift
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

/// Creates bootable macOS installer media from an installer app or DMG.
class MacOSProcess: DarwinProcess {

    let app: String
    let dev: String

    let quiet: Bool

    /// Creates a macOS media-creation process.
    ///
    /// - Parameters:
    ///   - app: The path to the macOS installer app or DMG.
    ///   - dev: The target disk device identifier.
    ///   - quiet: Suppresses the completion beep when `true`.
    init(app: String, dev: String, quiet: Bool) {
        self.app = app
        self.dev = dev
        self.quiet = quiet
    }


    /// Runs the macOS media creation pipeline.
    ///
    /// The pipeline checks privileges, formats the device, copies the installer
    /// app, ejects the volume, and signals success.
    func burn() async {
        // ---------------MACOS-------------------

        print(Constants.startMessageMacOS)

        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForMacOS(deviceURL: URL(filePath: "/dev/\(self.dev)")) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: { try Engine.copyToDevForMacOS(appURL: URL(filePath: self.app)) }
                ),
                Action(
                    message: Constants.statusEjectVolume,
                    action: { try await Engine.forceEjectVolume(deviceURL: URL(filePath: "/dev/\(self.dev)")) }
                ),
                Action(
                    message: Constants.statusSuccess,
                    action: { self.beep(self.quiet) }
                )
            ]
        ).runAll(
            catch: { error, action, spin in

                handleEngineError(error, action, spin)
            }
        )
    }
}
