//
//  InfoMap.swift
//  phaseclt
//
//  Created by Antonio Izquierdo Álvarez on 28/11/23.
//

import Foundation
import PListKit
import ArgumentParser

public protocol PListCompatible {}
extension String: PListCompatible {}
extension Int: PListCompatible {}
extension Double: PListCompatible {}
extension Bool: PListCompatible {}
extension Date: PListCompatible {}
extension Data: PListCompatible {}
extension Array: PListCompatible where Element: PListCompatible {}
extension Dictionary: PListCompatible where Key == String, Value: PListCompatible {}

enum Interface: String {
    case Main = "Main"
    case Creator = "Creator"
}

final class InfoMap: Sendable {
    
    static func loadCommandConfigurationKeys(
        cli: Interface,
        conf: CommandConfiguration
    ) -> CommandConfiguration {

        guard let url = Bundle.module.url(forResource: "Config", withExtension: "plist") else {
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        guard let data = try? DictionaryPList(url: url) else {
            
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        let dictionary = data.root.dict(key: "Interfaces")
        
        guard let interface = dictionary.dict(key: cli.rawValue).value else {
            
            print("❌ Error al cargar configuración")
            exit(1)
        }
        
        let commandName = interface["Name"] as? String ?? conf.commandName
        let abstract = interface["Abstract"] as? String ?? conf.abstract
        let discussion = interface["Discussion"] as? String ?? conf.discussion
        let version = interface["Version"] as? String ?? conf.version
        let aliases = interface["Aliases"] as? [String] ?? conf.aliases
        let usage = interface["Usage"] as? String ?? conf.usage
        
        return CommandConfiguration(
            commandName: commandName,
            abstract: abstract,
            version: version,
            subcommands: conf.subcommands,
            defaultSubcommand: conf.defaultSubcommand
        )
    }
}
