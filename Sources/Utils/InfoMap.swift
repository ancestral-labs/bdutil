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

final class InfoMap: Sendable {
    
    static let shared = InfoMap()
    
    private let mainData = Mutex<[String: String]>([:])
    private let creatorData = Mutex<[String: String]>([:])
    
    private init() {
        
        guard let url = Bundle.module.url(forResource: "Config", withExtension: "plist") else {
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        guard let data = try? DictionaryPList(url: url) else {
            
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        let dictionary = data.root.dict(key: "Interfaces")
        
        guard let mainInterface = dictionary.dict(key: Interface.Main.rawValue).value else {
            
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        mainInterface.forEach { key, value in
            self.mainData.withLock { dict in
                dict[key] = value as? String
            }
        }
        
        guard let creatorInterface = dictionary.dict(key: Interface.Creator.rawValue).value else {
            
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        creatorInterface.forEach { key, value in
            self.creatorData.withLock { dict in
                dict[key] = value as? String
            }
        }
    }
    
    func getValueMain(forKey key: String) -> String? {
        mainData.withLock { dict in
            dict[key]
        }
    }
    
    func getValueCreator(forKey key: String) -> String? {
        creatorData.withLock { dict in
            dict[key]
        }
    }
}
