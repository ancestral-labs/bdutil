//
//  PMap.swift
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
import PListKit
import ArgumentParser
import Synchronization

/// The metadata keys available for a command interface.
public enum Term: CaseIterable {
    case name
    case description
    case version

    /// The property-list key used to store this term.
    var key: String {
        switch self {
        case .name: return CommandConf.name.rawValue
        case .description: return CommandConf.abstract.rawValue
        case .version: return CommandConf.version.rawValue
        }
    }

    /// The fallback value used when this term is missing from the property list.
    var defValue: String {
        switch self {
        case .name: return Constants.defCommandName
        case .description: return Constants.defCommandAbstract
        case .version: return Constants.defCommandVersion
        }
    }
}

/// A thread-safe, read-only view over a command interface's metadata.
///
/// Each command interface (main, list, create, dos, unix, macos) is backed by a
/// lazily-created `PMap` instance that reads its values from the bundled
/// `Properties.plist` resource. Values are stored in a `Mutex` so the instances
/// can be shared safely.
public final class PMap: Sendable {

    /// Metadata for the root command.
    static let main = PMap(cli: .main)
    /// Metadata for the `list` subcommand.
    static let lister = PMap(cli: .lister)
    /// Metadata for the `create` subcommand.
    static let creator = PMap(cli: .creator)
    /// Metadata for the `create dos` subcommand.
    static let dos = PMap(cli: .dos)
    /// Metadata for the `create unix` subcommand.
    static let unix = PMap(cli: .unix)
    /// Metadata for the `create macos` subcommand.
    static let macos = PMap(cli: .macos)

    /// The parsed metadata, protected by a mutex.
    private let data = Mutex<[String: String]>([:])

    /// Loads and parses the metadata for the given command interface.
    ///
    /// - Parameter cli: The command interface to load.
    private init(cli: CommandInterface) {

        let fileName: String = Constants.propertyFileName
        let fileExt: String = Constants.propertyFileExtension

        guard let url = Bundle.module.url(forResource: fileName, withExtension: fileExt) else {
            handlePropertyError(message: Constants.propertyNFMsg, code: 1)
        }

        guard let data = try? DictionaryPList(url: url) else {

            handlePropertyError(message: Constants.propertyNRMsg, code: 1)
        }

        let dictionary = data.root.dict(key: Constants.propertyCLIDictionary)

        guard let dataInterface = dictionary.dict(key: cli.rawValue).value else {

            handlePropertyError(message: Constants.propertyWFMsg, code: 1)
        }

        dataInterface.forEach { key, value in

            self.data.withLock { dict in

                dict[key] = value as? String
            }
        }
    }

    /// Returns the value for a term, falling back to its default when absent.
    ///
    /// - Parameter term: The metadata key to look up.
    /// - Returns: The stored value, or the term's default.
    subscript(term: Term) -> String { return data.withLock { $0[term.key] ?? term.defValue } }
}

/// Terminates the process with an error message.
///
/// - Parameters:
///   - message: The message to print before exiting.
///   - code: The process exit code.
private func handlePropertyError(message: String, code: Int32) -> Never {
    print("❌ \(message)")
    exit(code)
}
