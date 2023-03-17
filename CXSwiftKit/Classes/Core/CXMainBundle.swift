//
//  CXMainBundle.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

import UIKit

@objcMembers public class CXMainBundle: NSObject {
    
    /// Constructed from the bundle’s Info.plist file, that contains information about the receiver.
    public static let infoDict = Bundle.main.infoDictionary ?? [:]
    
    /// The bundle identifier for an app.
    public static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? ""
    
    /// The display name for an app.
    public static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    
    /// The short version for an app.
    public static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    
    /// The build version for an app.
    public static let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    
    /// The executable file name for an app.
    public static let executableName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String ?? ""
    
}
