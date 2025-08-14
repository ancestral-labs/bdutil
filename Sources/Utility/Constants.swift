//
//  File.swift
//  PhaseCLT
//
//  Created by Antonio Izquierdo Álvarez on 26/6/25.
//

import Foundation

public enum CommandInterface: String, CaseIterable {
    case main = "Main"
    case creator = "Creator"
}

public enum CommandConf: String, CaseIterable {
    case name = "Name"
    case abstract = "Abstract"
    case version = "Version"
}

struct Constants {

    public static let defCommandName: String = "unknown"
    public static let defCommandAbstract: String = "No command description"
    public static let defCommandVersion: String = "0.0.0"

    public static let propertyFileName: String = "Properties"
    public static let propertyFileExtension: String = "plist"
    
    public static let propertyCLIDictionary: String = "Interfaces"
    
    public static let propertyNFMsg: String = "Property file not found"
    public static let propertyNRMsg: String = "Property file not reachable"
    public static let propertyWFMsg: String = "Wrong property file format"
    
    public static let argHelpOSType: String = "Operating system installation type: dos, unix or macos"
    public static let argHelpImg: String = "Disc image or app file path"
    public static let argHelpDev: String = "Disk path"
    
    public static let startMessageDOS: String = "Creating DOS bootable device"
    public static let startMessageUNIX: String = "Creating UNIX bootable device"
    public static let startMessageMacOS: String = "Creating macOS bootable device"
    
    public static let statusCheckPrivs: String = "Checking user privileges"
    public static let statusMountImg: String = "Mounting image"
    public static let statusFormatDev: String = "Formatting device"
    public static let statusCopyFiles: String = "Copying files"
    public static let statusUnmountImg: String = "Unmounting image"
    public static let statusEjectVolume: String = "Ejecting volume"
    public static let statusSuccess: String = "Finishing bootable media creation"
    
    public static let msgUnexpectedError: String = "Unexpected error"
}
