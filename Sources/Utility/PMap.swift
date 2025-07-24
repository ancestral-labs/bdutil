//
//  InfoMap.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import Foundation
import PListKit
import ArgumentParser
import Synchronization

public enum Term: CaseIterable {
    case name
    case description
    case version

    var key: String {
        switch self {
        case .name: return CommandConf.name.rawValue
        case .description: return CommandConf.abstract.rawValue
        case .version: return CommandConf.version.rawValue
        }
    }

    var defValue: String {
        switch self {
        case .name: return Constants.defCommandName
        case .description: return Constants.defCommandAbstract
        case .version: return Constants.defCommandVersion
        }
    }
}

public final class PMap: Sendable {
    
    static let main = PMap(cli: .main)
    static let creator = PMap(cli: .creator)
    
    private let data = Mutex<[String: String]>([:])
    
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
    
    subscript(term: Term) -> String { return data.withLock { $0[term.key] ?? term.defValue } }
}

private func handlePropertyError(message: String, code: Int32) -> Never {
    print("❌ \(message)")
    exit(code)
}
