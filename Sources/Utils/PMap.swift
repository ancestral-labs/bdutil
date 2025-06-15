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

public protocol PListCompatible {}
extension String: PListCompatible {}
extension Int: PListCompatible {}
extension Double: PListCompatible {}
extension Bool: PListCompatible {}
extension Date: PListCompatible {}
extension Data: PListCompatible {}
extension Array: PListCompatible where Element: PListCompatible {}
extension Dictionary: PListCompatible where Key == String, Value: PListCompatible {}

enum Interface: String, CaseIterable {
    case Main = "Main"
    case Creator = "Creator"
}

final class PMap: Sendable {
    
    static let main = PMap(cli: .Main)
    static let creator = PMap(cli: .Creator)
    
    private let data = Mutex<[String: String]>([:])
    
    private init(cli: Interface) {
        
        guard let url = Bundle.module.url(forResource: "Config", withExtension: "plist") else {
            handlePropertyError(message: "❌ Impossible to read the property file", code: 1)
        }
        
        guard let data = try? DictionaryPList(url: url) else {
            
            handlePropertyError(message: "❌ Impossible to read the property file", code: 1)
        }
        
        let dictionary = data.root.dict(key: "Interfaces")
        
        guard let dataInterface = dictionary.dict(key: cli.rawValue).value else {
            
            handlePropertyError(message: "❌ Impossible to read the property file", code: 1)
        }
        
        dataInterface.forEach { key, value in
            
            self.data.withLock { dict in
                
                dict[key] = value as? String
            }
        }
    }
    
    subscript(key: String) -> String? {
        
        get {
            
            return data.withLock { $0[key] }
        }
    }
}

private func handlePropertyError(message: String, code: Int32) -> Never {
    print("❌ \(message)")
    exit(code)
}
