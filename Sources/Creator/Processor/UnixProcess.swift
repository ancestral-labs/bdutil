//
//  UnixProcess.swift
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

/// Creates bootable Linux/UNIX media from an ISO image.
class UnixProcess: StandardProcess {

    let image: String
    let dev: String

    let quiet: Bool

    /// Creates a UNIX media-creation process.
    ///
    /// - Parameters:
    ///   - image: The path to the Linux/UNIX ISO image.
    ///   - dev: The target disk device identifier.
    ///   - quiet: Suppresses the completion beep when `true`.
    init(image: String, dev: String, quiet: Bool) {
        self.image = image
        self.dev = dev
        self.quiet = quiet
    }


    /// Runs the UNIX media creation pipeline.
    ///
    /// The pipeline checks privileges, formats the device, copies the image,
    /// ejects the volume, and signals success.
    func burn() async {
        // ---------------UNIX-------------------

        print(Constants.startMessageUNIX)

        await Scheduler(
            actions: [
                Action(
                    message: Constants.statusCheckPrivs,
                    action: { try Engine.checkPrivileges() }
                ),
                Action(
                    message: Constants.statusFormatDev,
                    action: { try Engine.formatDeviceForUNIX(deviceURL: URL(filePath: "/dev/\(self.dev)")) }
                ),
                Action(
                    message: Constants.statusCopyFiles,
                    action: {
                        try Engine.copyToDevForUNIX(
                            isoURL: URL(filePath: self.image),
                            devURL: URL(filePath: "/dev/\(self.dev)")
                        )
                    }
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
